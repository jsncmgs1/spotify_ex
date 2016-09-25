# Changelog

## 2.0.0

- SpotifyEx now uses a Credentials struct internally to remove the coupling to
  Plug.Conn. This allows us to use the library with tools other than the
  browser, like slack bots.  Thanks adamzaninovich!

- Fix an infinite loop in Playlist.add_tracks
- On HTTP error in the authentication client, return a 3 element tuple instead
  of 2, since we won't return a conn. This is the only breaking API change.

- Removed the following functions in `Spotify.Cookies`:
  1. `Spotify.Cookies.get_cookies_from_response/1` in favor of `Spotify.Credentials.get_tokens_from_response/1'
  2. `Spotify.Cookies.get_access_cookie/1` in favor of `Spotify.Credentials.get_access_token/1`
  3. `Spotify.Cookies.get_refresh_cookie/1` in favor of `Spotify.Credentials.get_refresh_token/1`

## 1.0.3

- Use `>=` instead of `~>` for Poison dependancy to Allow Poison 2.0
- Bump Plug to 1.2.0

