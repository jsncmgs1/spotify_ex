# Spotify
**Elixir wrapper for the Spotify Web API.  This should be considered an alpha version and is subject to breaking changes.**

## Installation

Currently this package only implements the O-auth portion of the api, and a tiny part of Playlist, for testing purposes.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add spotify_ex to your list of dependencies in `mix.exs`:

        def deps do
          [{:spotify_ex, "~> 0.0.1"}]
        end

  2. Ensure spotify_ex is started before your application:

        def application do
          [applications: [:spotify_ex]]
        end

## Usage

The Spotify API follows the O Auth 2 spec, providing 3 potential authentication flows:

- ** [Authorization Code flow](https://developer.spotify.com/web-api/authorization-guide/#authorization_code_flow) **
- ** [Client Credentials Flow](https://developer.spotify.com/web-api/authorization-guide/#client_credentials_flow)**
- ** [Implicit Grant Flow](https://developer.spotify.com/web-api/authorization-guide/#implicit_grant_flow)**

To connect with the Spotify API, first you must register your app with Spotify, and get your **Client ID** and **Client Secret**, which are necessary for authentication.

In ```/config```
1. Don't check in your credentials to version control, make some secret config file and import it in your ```config.exs file```.
2. Create ```config/secret.exs``` and ```config/spotify.exs``` files

```elixir
#secret.exs

use Mix.Config

config :spotify_ex, client_id: "<YOUR CLIENT ID>"
config :spotify_ex, secret_key: "<YOUR SECRET KEY>"
```

```elixir
#spotify.exs

use Mix.Config

config :spotify_ex, client_id: "<YOUR CLIENT ID>",
                    secret_key: "<YOUR SECRET KEY>",
                    user_id: "<YOUR SPOTIFY USER ID>",
                    scopes: "<AUTHENTICATION SCOPES>",
                    callback_url: "<YOUR CALLBACK URL>"
```

Add the secret file to your .gitignore,  and import it in config.exs

```elixir
import "config.secret.exs"
import "spotify.secret.exs"
```

## Authorization Flow

First your application must be *authorized* by Spotify. SpotifyEx will use the client ID, callback URI, and scopes set in your config file to request the authorization endpoint.

## Phoenix example (Example app found at [SpotifyExTest](http://www.github.com/jsncmgs1/spotify_ex_test]))

```elixir
defmodule SpotifyExTest.AuthorizationController do
  use SpotifyExTest.Web, :controller

  def authorize(conn, _params) do
    redirect conn, external: Spotify.Authorization.call
  end
end
```

This will take you to the Spotify Authorization page.  After authorizing your app, you will be directed to now authenticate as a Spotify User. When successfull, you will be redirected to the callback uri you set in the config file.


### A note about scopes

Use ust be explicit about the permissions your users have when handling Spotify account data.  These permissions are set oduring the authorization request.  You can read about them [here](https://developer.spotify.com/web-api/using-scopes/).
To set your scopes, add them to the list in your ```spotify.exs``` file,

```elixir
#config/spotify.exs

config :spotify_ex, scopes: ["playlist-read-private", "playlist-modify-private" "# more scopes"]
```

O-auth requires a redirect URI. When you attempt to authenticate with Spotify, if successful, Spotify needs to know where to send the user afterwards. The redirect URI tells Spotify where to send them.

```elixir
config :spotify_ex, callback_url: "http://www.your-api.com/auth-endpoint"
```

Set it in your config file. Now that your application is *authorized*, the user must be *authenticated*. Spotify is going to send an authorization code in the query string to this endpoint, which should then send that code to Spotify to request an **access token** and a **remember token**.

```elixir
config :spotify_ex, callback_url: "http://localhost:4000/authenticate"
```

Authenticate like this:

```elixir
Spotify.Authentication.authenticate(conn, params)
```

Spotify.Authentication.authenticate will look for params["code"]; the code sent back from the authorization request, everything else is taken care of.  If successful, the user will be redirected to the URL set in the ```spotify.exs``` file, where you can handle different responses

```elixir
defmodule SpotifyExTest.AuthenticationController do
  use SpotifyExTest.Web, :controller

  def authenticate(conn, params) do
    case Spotify.Authentication.call(conn, params) do
      { 200, conn, %{"access_token" => _token} } ->
        redirect conn, to: "/whereever-you-want-to-go"
      { 404, _ } -> redirect conn, to: "/error"
      { 500, _ }-> redirect conn, to: "/error"
    end
  end
end
```

Then authentication module will set refresh and access tokens in a cookie. The access token expires every hour, future portions of the api, will handle this for you, but for now you'll need to check for a 401 status in your responses and call Spotify.Authentication.refresh, if there is a refresh token present.  If not, you'll need to redirect back to Authorization.

```elixir
defmodule SpotifyExTest.PlaylistController do
  use SpotifyExTest.Web, :controller
  plug :check_tokens

  def index(conn, _params) do
    case Spotify.Playlist.current_user_playlists(conn) do
      :authorize -> redirect conn, external: Spotify.Authorization.call
      { 200, playlists } ->
        render conn, "index.html", playlists: playlists
    end
  end

  defp check_tokens(conn, _params) do
    unless Spotify.Authentication.tokens_present?(conn) do
      redirect conn, external: Spotify.Authorization.call
    end
    conn
  end
end

defmodule Spotify.Playlist do
  def current_user_playlists(conn) do
    case HTTPoison.get("https://api.spotify.com/v1/users/#{Spotify.current_user}/playlists", headers(conn)) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, %{ "items" => items }} = Poison.decode(body)
          {200, items}
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          { 404, "Not found :(" }
        {:ok, %HTTPoison.Response{status_code: 401, body: _body}} ->
          if Spotify.Authentication.get_refresh_token do
            { 200, conn, %{ "access_token" => access_token }} = Spotify.Authentication.refresh(conn)
            conn = Spotify.Authentication.set_access_cookie(conn, access_token)
            current_user_playlists(conn)
          else
            :authorize
          end
        {:error, %HTTPoison.Error{reason: reason}} ->
          { 500, reason }
    end
  end

  def headers(conn) do
    [
      {"Authorization", "Bearer #{Spotify.Authentication.get_access_cookie(conn)}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end
end
```
