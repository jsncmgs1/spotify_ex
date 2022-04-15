import Config

config :spotify_ex,
  auth_client: Spotify.Authentication,
  callback_url: "http://localhost:4200/authenticate",
  scopes: ["playlist-modify-public", "playlist-modify-private"]
