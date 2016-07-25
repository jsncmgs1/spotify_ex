defmodule PlaylistTest do
  use ExUnit.Case
  alias Spotify.Playlist, as: Playlist

  describe "featured" do
    test "featured/0 returns the playlist url" do
      assert Playlist.featured == "https://api.spotify.com/v1/browse/featured-playlists"
    end

    test "featured/1 adds query params to the url when given a keyword list" do
      params = [foo: :bar, baz: "bux"]
      expected = "https://api.spotify.com/v1/browse/featured-playlists" <> "?foo=bar&baz=bux"

      assert Playlist.featured(params) == expected
    end

    test "featured/1 adds query params to the url when given a map" do
      params = %{ foo: :bar, baz: "bux" }
      expected = "https://api.spotify.com/v1/browse/featured-playlists" <> "?baz=bux&foo=bar"

      assert Playlist.featured(params) == expected
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
  end

  test "follow_playlist/2" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456/followers"
    assert Playlist.follow_playlist("123", "456") == expected
  end

  test "unfollow_playlist/2" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456/followers"
    assert Playlist.follow_playlist("123", "456") == expected
  end

  test "search/1" do
    expected = "https://api.spotify.com/v1/search?type=playlist&q=foo&limit=5"
    assert Playlist.search(q: "foo", limit: 5) == expected
  end

  describe "get_users_playlist" do
    test "get_users_playlists/1" do
      expected = "https://api.spotify.com/v1/users/123/playlists"
      assert Playlist.get_users_playlists("123") == expected
    end

    test "get_users_playlist/2" do
      expected = "https://api.spotify.com/v1/users/123/playlists?limit=5"
      assert Playlist.get_users_playlists("123", limit: 5) == expected
    end
  end

  describe "get_playlist" do
    test "get_playlist/2" do
      expected = "https://api.spotify.com/v1/users/123/playlists/456"
      assert Playlist.get_playlist("123", "456") == expected
    end

    test "get_playlist/3" do
      expected = "https://api.spotify.com/v1/users/123/playlists/456?market=foo"
      assert Playlist.get_playlist("123", "456", market: "foo") == expected
    end
  end

  describe "get_playlist_tracks" do
    test "get_playlist_tracks/2" do
      expected = "https://api.spotify.com/v1/users/123/playlists/456/tracks"
      assert Playlist.get_playlist_tracks("123", "456") == expected
    end
    test "get_playlist_tracks/3" do
      expected = "https://api.spotify.com/v1/users/123/playlists/456/tracks?limit=5&offset=5"
      assert Playlist.get_playlist_tracks("123", "456", limit: 5, offset: 5) == expected
    end
  end

  test "create_playlist/1" do
    expected = "https://api.spotify.com/v1/users/123/playlists"
    assert Playlist.create_playlist("123") == expected
  end

  test "change_playlist/1" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456"
    assert Playlist.change_playlist("123", "456") == expected
  end

  test "add_tracks/3" do
    actual = Playlist.add_tracks("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
    expected = "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh"
    assert actual == expected
  end

  test "remove_tracks/2" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456/tracks"
    assert Playlist.remove_tracks("123", "456") == expected
  end

  test "reorder_tracks/2" do
    expected = "https://api.spotify.com/v1/users/123/playlists/456/tracks"
    assert Playlist.remove_tracks("123", "456") == expected
  end

  test "replace_tracks/3" do
    actual = "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh%2Cspotify%3Atrack%3Aadkjaklsd94h"
    expected = Spotify.Playlist.replace_tracks("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh,spotify:track:adkjaklsd94h")
    assert actual == expected
  end

  test "check_followers/3" do
    actual = "https://api.spotify.com/v1/users/123/playlists/456/followers/contains?ids=foo%2Cbar"
    expected = Playlist.check_followers("123", "456", ids: "foo,bar")
    assert actual == expected
  end
end
