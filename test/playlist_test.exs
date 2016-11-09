defmodule PlaylistTest do
  use ExUnit.Case
  alias Spotify.Playlist

  describe "build_response/1" do
    test "the API returns a playlist element" do
      actual = Playlist.build_response(response_body_with_playlist_element)
      playlists = [%Playlist{name: "foo"}, %Playlist{name: "bar"}]
      expected = %Paging{items: playlists}

      assert actual == expected
    end

    test "the API returns a items collections without a playlists root" do
      actual = Playlist.build_response(response_body_without_playlist_element)
      playlists = [%Playlist{name: "foo"}, %Playlist{name: "bar"}]
      expected = %Paging{items: playlists}

      assert actual == expected
    end
  end

  test "%Spotify.Playlist{}" do
    expected = ~w[collaborative description external_urls followers
    href id images name owner public snapshot_id tracks type uri]a

    actual = %Playlist{} |> Map.from_struct |> Map.keys
    assert actual == expected
  end

  def response_body_with_playlist_element do
    %{
      "playlists" => %{
        "items" => [%{ "name" => "foo" }, %{ "name" => "bar" } ]
      }
    }
  end

  def response_body_without_playlist_element do
    %{"items" => [%{ "name" => "foo" }, %{ "name" => "bar" } ]}
  end

end
