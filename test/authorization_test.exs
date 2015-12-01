defmodule SpotifyAuthorizationTest do
  use ExUnit.Case
  doctest Spotify.Authorization

  test "#authorize_endpoint with scopes" do
    Application.put_env(:spotify_ex, :scopes, ["foo", "bar"])
    assert(Spotify.Authorization.authorize_endpoint == "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}&scopes=foo+bar")
  end

  test "#authorize_endpoint without scopes" do
    Application.put_env(:spotify_ex, :scopes, [])

    assert(Spotify.Authorization.authorize_endpoint == "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}")
  end
end
