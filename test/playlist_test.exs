defmodule PlaylistTest do
  use ExUnit.Case
  alias Spotify.Playlist, as: Playlist
  doctest Playlist

  @url "https://api.spotify.com/v1/browse/featured-playlists"

  describe "featured" do
    test "featured/0 returns the playlist url" do
      assert Playlist.featured == @url
    end

    test "featured/1 adds query params to the url when given a keyword list" do
      params = [foo: :bar, baz: "bux"]
      expected = @url <> "?foo=bar&baz=bux"

      assert Playlist.featured(params) == expected
    end

    test "featured/1 adds query params to the url when given a map" do
      params = %{ foo: :bar, baz: "bux" }
      expected = @url <> "?baz=bux&foo=bar"

      assert Playlist.featured(params) == expected
    end

    test "featured raises an error if parmas is not a map or lost" do
      assert_raise FunctionClauseError, fn ->
        Playlist.featured(1)
      end
    end
  end

  describe "by_category" do
    test "by_category/1" do
      expected = "https://api.spotify.com/v1/browse/categories/123/playlists"
      assert Playlist.by_category(123) == expected
    end

    test "by_category/2" do
      expected = "https://api.spotify.com/v1/browse/categories/123/playlists?country=US&limit=5"
      assert Playlist.by_category(123, country: "US", limit: 5) == expected
    end

    test "featured raises an error if parmas is not a map or lost" do
      assert_raise FunctionClauseError, fn ->
        Playlist.by_category(1, 2)
      end
    end
  end

  test "follow_playlist/2" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456/followers"
    assert Playlist.follow_playlist("123", "456")
  end

  test "unfollow_playlist/2" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456/followers"
    assert Playlist.follow_playlist("123", "456")
  end

end
