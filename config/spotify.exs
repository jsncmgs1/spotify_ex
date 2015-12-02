use Mix.Config

config :spotify_ex, callback_url: "http://localhost:4200/authenticate"
config :spotify_ex, scopes: ["playlist-modify-public", "playlist-modify-private"]
