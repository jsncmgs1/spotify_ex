defmodule SpotifyAuthorizationTest do
  use ExUnit.Case
  doctest Spotify.Authorization

  test "#call with scopes" do
    Application.put_env(:spotify_ex, :scopes, ["foo", "bar"])
    assert(Spotify.Authorization.call == "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}&scopes=foo+bar")
  end

  test "#call without scopes" do
    Application.put_env(:spotify_ex, :scopes, [])

    assert(Spotify.Authorization.call == "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}")
  end
end
