defmodule SpotifyAuthorizationTest do
  use ExUnit.Case
  doctest Spotify.Authorization

  setup do
    Application.put_env(:spotify_ex, :client_id, "123")
    Application.put_env(:spotify_ex, :scopes, ["foo-bar", "baz-qux"])
  end

  describe ".url" do
    test "with scopes" do
      url = "https://accounts.spotify.com/authorize?client_id=123&response_type=code&redirect_uri=#{Spotify.callback_url}&scope=foo-bar%20baz-qux"
      assert(Spotify.Authorization.url == url)
    end

    test "without scopes" do
      Application.put_env(:spotify_ex, :scopes, [])
      url = "https://accounts.spotify.com/authorize?client_id=123&response_type=code&redirect_uri=#{Spotify.callback_url}"

      assert(Spotify.Authorization.url == url)
    end
  end

  test ".scopes" do
    assert Spotify.Authorization.scopes == "foo-bar%20baz-qux"
  end

end
