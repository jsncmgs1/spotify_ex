![Elixir CI](https://github.com/jsncmgs1/spotify_ex/workflows/Elixir%20CI/badge.svg)
[![Inline docs](http://inch-ci.org/github/jsncmgs1/spotify_ex.svg?branch=master)](http://inch-ci.org/github/jsncmgs1/spotify_ex)

# SpotifyEx
**Elixir Wrapper for the Spotify Web API**

This is no longer under development, though I'm happy to merge bug fixes and reasonable feature additions. Please ask before adding new features so you don't waste your time.

## [Documentation](https://hexdocs.pm/spotify_ex/api-reference.html)

## Installation

1. Add spotify_ex to your list of dependencies in `mix.exs`:

```elixir
def deps do
 [{:spotify_ex, "~> 2.3.0"}]
end
 ```

2. Ensure spotify_ex is started before your application:

```elixir
def application do
  [applications: [:spotify_ex]]
end
```

This wrapper covers the [Spotify Web
API](https://developer.spotify.com/web-api/endpoint-reference/).

Follow the abovementioned link. On the left you'll notice that the API is broken into
sections, such as Artists, Albums, Playlists, etc. This wrapper does its best
to keep endpoints in modules mapped to their corresponding section. However,
Spotify duplicates many of its endpoints. For example, there is an endpoint to
obtain an artist's albums that is listed under both Artists and Albums. 

Endpoints are not duplicated here, however. If you don't see an endpoint, it can be found in a
module that's also related to that endpoint. In other words, if you don't see an endpoint for "get artists albums"
in the `Artist` module, check `Albums`.

These duplicate endpoints may get aliased in the future to have a 1-1 mapping
with the docs.

## Usage

[docs](https://hexdocs.pm/spotify_ex/api-reference.html)

**A basic Phoenix example can be found at
[SpotifyExTest](http://www.github.com/jsncmgs1/spotify_ex_test)**

## OAuth
[Oauth README](https://github.com/jsncmgs1/spotify_ex/blob/master/docs/oauth.md)

### Scopes

[Scopes README](https://github.com/jsncmgs1/spotify_ex/blob/master/docs/scopes.md)

## Contributing

All contributions are more than welcome! I will not accept a PR without tests
if it looks like something that should be tested (which is pretty much
everything.) Development is done on the `development` branch, and moved to
`master` for release on hexpm. Code must be formatted using `hex format`.
