defmodule PlaylistTest do
  use ExUnit.Case
  alias Spotify.Playlist

  describe "build_response/1" do
    test "the API returns a collection" do
      actual = Playlist.build_response(response_body_with_collection)
      collection = [%Playlist{name: "foo"}, %Playlist{name: "bar"}]
      playlists = Enum.map(collection, &playlist/1)
      expected = paging(%Paging{items: playlists})

      assert actual == expected
    end

    test "the API returns a single playlist" do
      actual = Playlist.build_response(response_body_with_playlist)
      expected = playlist(%Playlist{name: "foo"})

      assert actual == expected
    end
  end

  test "%Spotify.Playlist{}" do
    attrs = ~w[collaborative description external_urls followers
    href id images name owner public snapshot_id tracks type uri]a

    expected = Map.from_struct(%Playlist{}) |> Map.keys

    assert expected == attrs
  end

  def paging(pager), do: Map.merge(%Paging{}, pager)
  def playlist(playlist), do: Map.merge(%Playlist{}, playlist)

  def response_body_with_collection do
    %{
      "playlists" => %{
        "items" => [%{ "name" => "foo" }, %{ "name" => "bar" } ]
      }
    }
  end

  def response_body_with_playlist, do: %{ "name" => "foo" }
end
