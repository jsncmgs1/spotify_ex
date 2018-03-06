use Mix.Config

Path.wildcard("test/*mock*")
|> Enum.each(&Code.require_file("../#{&1}", __DIR__))

Code.ensure_loaded(Plug.Conn)
Code.ensure_loaded(HTTPoison.Response)

config :spotify_ex, auth_client: Spotify.AuthenticationClientMock
