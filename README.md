![Elixir CI](https://github.com/jsncmgs1/spotify_ex/workflows/Elixir%20CI/badge.svg)
[![Inline docs](http://inch-ci.org/github/jsncmgs1/spotify_ex.svg)](http://inch-ci.org/github/jsncmgs1/spotify_ex)
[![Hex docs](https://hexdocs.pm/spotify_ex/api-reference.html)]

# SpotifyEx
**Elixir Wrapper for the Spotify Web API**

## Installation

1. Add spotify_ex to your list of dependencies in `mix.exs`:

```elixir
def deps do
 [{:spotify_ex, "~> 2.1.0"}]
end
 ```

2. Ensure spotify_ex is started before your application:

```elixir
def application do
  [applications: [:spotify_ex]]
end
```

[Documentation](https://hexdocs.pm/spotify_ex/api-reference.html)

## What does this wrapper cover?

This wrapper covers the [Spotify Web
API](https://developer.spotify.com/web-api/endpoint-reference/).

Follow the abovementioned link. On the left you'll notice that the API is broken into
sections, such as Artists, Albums, Playlists, etc. This wrapper does its best
to keep endpoints in modules mapped to their corresponding section. However,
Spotify duplicates many of its endpoints. For example, there is an endpoint to
obtain an artist's albums that is listed under both Artists and Albums. The endpoints
are not duplicated in this wrapper, so if you don't see an endpoint, it can be found in a
module that's also related to that endpoint i.e, if you don't see that endpoint
in the `Artist` module, check `Albums`.

These duplicate endpoints may get aliased in the future to have a 1-1 mapping
with the docs.

## Usage

This README will go into some detail about the OAuth process. Consult the
[docs](https://hexdocs.pm/spotify_ex/api-reference.html) for other parts
of the API.

I haven't made any functions private because I think programmer should have
access to all of the functions. Anything not documented should be considered
private with respect to the API and can change. Use at your own risk.

There are 2 functions for each endpoint. For example, to get a playlist,
`Spotify.Playlist.get_playlist`, and `Spotify.Playlist.get_playlist_url` are available.  The
first will use the url function to make the request, and return
a list of `%Spotify.Track` structs.  If you just want the raw response from
Spotify and/or want to implement your own client and data manipulation, all of
the url functions are public.

**A basic Phoenix example can be found at
[SpotifyExTest](http://www.github.com/jsncmgs1/spotify_ex_test)**

## OAuth

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


### A note about scopes

You must be explicit about the permissions your users have when handling
Spotify account data.  These permissions are set during the authorization
request.  You can read about them
[here](https://developer.spotify.com/web-api/using-scopes/).  To set your
scopes, add them to the list in your ```spotify.exs``` file,

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

## Contributing

All contributions are more than welcome! I will not accept a PR without tests
if it looks like something that should be tested (which is pretty much
everything.) Development is done on the `development` branch, and moved to
`master` for release on hexpm. Code must be formatted using `hex format`.
