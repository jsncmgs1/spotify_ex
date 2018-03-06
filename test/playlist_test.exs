defmodule PlaylistTest do
  use ExUnit.Case
  alias Spotify.Playlist

  describe "build_response/1" do
    test "the API returns a playlist element" do
      actual = Playlist.build_response(response_body_with_playlist_element())

      expected = %Paging{
        href: "https://api.spotify.com/v1/users/anuser/playlists?offset=0&limit=20",
        items: [%Playlist{name: "foo"}, %Playlist{name: "bar"}],
        limit: 20,
        next: "https://api.spotify.com/v1/users/anuser/playlists?offset=20&limit=20",
        offset: 0,
        previous: nil,
        total: 62
      }

      assert actual == expected
    end

    test "the API returns a items collections without a playlists root" do
      actual = Playlist.build_response(response_body_without_playlist_element())

      expected = %Paging{
        href: "https://api.spotify.com/v1/users/anuser/playlists?offset=0&limit=20",
        items: [%Playlist{name: "foo"}, %Playlist{name: "bar"}],
        limit: 20,
        next: "https://api.spotify.com/v1/users/anuser/playlists?offset=20&limit=20",
        offset: 0,
        previous: nil,
        total: 62
      }

      assert actual == expected
    end
  end

  test "%Spotify.Playlist{}" do
    expected = ~w[collaborative description external_urls followers
    href id images name owner public snapshot_id tracks type uri]a

    actual = %Playlist{} |> Map.from_struct() |> Map.keys()
    assert actual == expected
  end

  def response_body_with_playlist_element do
    %{
      "playlists" => %{
        "href" => "https://api.spotify.com/v1/users/anuser/playlists?offset=0&limit=20",
        "items" => [%{"name" => "foo"}, %{"name" => "bar"}],
        "limit" => 20,
        "next" => "https://api.spotify.com/v1/users/anuser/playlists?offset=20&limit=20",
        "offset" => 0,
        "previous" => nil,
        "total" => 62
      }
    }
  end

  def response_body_without_playlist_element do
    %{
      "href" => "https://api.spotify.com/v1/users/anuser/playlists?offset=0&limit=20",
      "items" => [%{"name" => "foo"}, %{"name" => "bar"}],
      "limit" => 20,
      "next" => "https://api.spotify.com/v1/users/anuser/playlists?offset=20&limit=20",
      "offset" => 0,
      "previous" => nil,
      "total" => 62
    }
  end
end
