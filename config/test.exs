use Mix.Config

Path.wildcard("test/mocks/**")
|> Enum.filter(&String.match?(&1, ~r/mock/))
|> Enum.each(&Code.require_file("../#{&1}", __DIR__))

config :spotify_ex,
  auth_client: Spotify.AuthenticationClientMock
