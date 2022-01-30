The Spotify API follows the OAuth 2 spec, providing 3 potential authentication flows:

- [Authorization Code flow](https://developer.spotify.com/web-api/authorization-guide/#authorization_code_flow)
- [Client Credentials Flow](https://developer.spotify.com/web-api/authorization-guide/#client_credentials_flow)
- [Implicit Grant Flow](https://developer.spotify.com/web-api/authorization-guide/#implicit_grant_flow)

To connect with the Spotify API, first you must register your app with Spotify,
and get your **Client ID** and **Client Secret**, which are necessary for
authentication.

In ```/config```, create ```config/secret.exs``` and ```config/spotify.exs``` files

```elixir
# /config/secret.exs

use Mix.Config

config :spotify_ex, client_id: "<YOUR CLIENT ID>"
                    secret_key: "<YOUR SECRET KEY>"
```

```elixir
# /config/spotify.exs

use Mix.Config

config :spotify_ex, user_id: "<YOUR SPOTIFY USER ID>",
                    scopes: "<AUTHENTICATION SCOPES>",
                    callback_url: "<YOUR CALLBACK URL>"
```

Add the secret file to your .gitignore,  and import it in config.exs

```elixir
import "config.secret.exs"
import "spotify.secret.exs"
```

## Authorization Flow

First your application must be *authorized* by Spotify. SpotifyEx will use the
client ID, callback URI, and scopes set in your config file to generate the
authorization endpoint.

```elixir
defmodule SpotifyExTest.AuthorizationController do
  use SpotifyExTest.Web, :controller

  def authorize(conn, _params) do
    redirect conn, external: Spotify.Authorization.url
  end
end
```

This will take you to the Spotify Authorization page.  After authorizing your
app, you will then be directed to authenticate as a Spotify User. When
successful, you will be redirected to the callback uri you set in the config
file.

```elixir
#config/spotify.exs

config :spotify_ex, scopes: ["playlist-read-private", "playlist-modify-private" "# more scopes"]
```

OAuth requires identical redirect URIs to use for the authorization and
authentication steps. When you attempt to authenticate with Spotify, if
successful, Spotify needs to know where to send the user afterwards, which
is what the redirect URI is used for.

```elixir
config :spotify_ex, callback_url: "http://www.your-api.com/auth-endpoint"
```

Set it in your config file. Now that your application is *authorized*, the user
must be *authenticated*. Spotify is going to send an authorization code in the
query string to this endpoint, which should then send that code to Spotify to
request an **access token** and a **remember token**.

```elixir
config :spotify_ex, callback_url: "http://localhost:4000/authenticate"
```

Authenticate like this:

```elixir
Spotify.Authentication.authenticate(conn, params)
```

`Spotify.Authentication.authenticate` will look for `params["code"]`,the code
sent back by Spotify after authorization request. If successful, the user will
be redirected to the URL set in the ```spotify.exs``` file, where you can
handle different responses.

```elixir
defmodule SpotifyExTest.AuthenticationController do
  use SpotifyExTest.Web, :controller

  def authenticate(conn, params) do
    case Spotify.Authentication.authenticate(conn, params) do
      {:ok, conn } ->
        # do stuff
        redirect conn, to: "/whereever-you-want-to-go"
      { :error, reason, conn }-> redirect conn, to: "/error"
    end
  end
end
```

The authentication module will set refresh and access tokens in a cookie. The
access token expires every hour, so you'll need to check your reponses for 401
errors. Call `Spotify.Authentication.refresh`, if there is a refresh token
present.  If not, you'll need to redirect back to authorization.
