defmodule SpotifyAuthorizationTest do
  use ExUnit.Case
  doctest Spotify.Authorization

  test "#call with scopes" do
    Application.put_env(:spotify_ex, :scopes, ["foo", "bar"])
    url = "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}&scope=foo%20bar"
    assert(Spotify.Authorization.call == url)
  end

  test "#call without scopes" do
    Application.put_env(:spotify_ex, :scopes, [])
    url = "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}"

    assert(Spotify.Authorization.call == url)
  end
end
