# Spotify
# TODO::
  1. Generate spotify.exs and add scopes []

**Elixir wrapper for the Spotify Web API**

## Installation

Currently this package only implements the O-auth portion of the api.

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

To connect with the Spotify API, first you must register your app with Spotify, and get your **Client ID** and **Client Secret**, which are neccessary for authentication.

In ```/config```
1. Don't check in your credentials to version control, make some secret config file and import it in your ```config.exs file```.
2. Create a ```spotify.exs``` file

```elixir
#config.secret.exs

use Mix.Config

config :spotify_ex, client_id: "<YOUR CLIENT ID>"
config :spotify_ex, secret_key: "<YOUR SECRET KEY>"
```

Add this file to your .gitignore,  and import it in config.exs

```elixir
import "config.secret.exs"
import "spotify.secret.exs"
```

## Authorization Flow

First your application must be authorized by Spotify. Use

```elixir
Spotify.Authorization.authorize_endpoint
```

to make the request.  Your client id and secret key *must* be defined.

### A note about scopes

Use ust be explicit about the permissions your users have when handling Spotify account data.  These permissions are set oduring the authorization request.  You can read about them (here)[https://developer.spotify.com/web-api/using-scopes/].
To set your scopes, add them to the list in your ```spotify.exs``` file,

```elixir
#config/spotify.exs

config :spotify_ex, scopes: ["playlist-read-private", "playlist-modify-private" "# more scopes"]
```

O auth requres a redirect URI. When you attempt to authenticate with Spotify, if successful, Spotify needs to know where to send the user afterwards. The redirect URI tells Spotify where to send them.

```elixir
config :spotify_ex, callback_url: "http://www.your-api.com/auth-endpoint"
```

Set it in your config file. Spotify is going to send an authorization code in the query string to this endpoint, which should then send that code to Spotify to request an **access token** and a **remember token**.

config :spotify_ex, callback_url: "http://localhost:4200/authenticate"

Authenticate like this:

```elixir
Spotify.Authentication.authenticate(conn, params)
```

Spotify.Authentication.authenticate will look for params["code"]; the code sent back from the authorization request, everything else is taken care of.  If successful, the user will be redirected to the URL set in the ```spotify.exs``` file
