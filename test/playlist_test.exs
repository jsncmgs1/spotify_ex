defmodule PlaylistTest do
  use ExUnit.Case
  alias Spotify.Playlist

  describe "build_response/1" do
    test "the API returns a collection" do
      actual = Playlist.build_response(response_body_with_collection)
      playlists = [%Playlist{name: "foo"}, %Playlist{name: "bar"}]
      expected = %Paging{items: playlists}

      assert actual == expected
    end

    test "the API returns a single playlist" do
      actual = Playlist.build_response(response_body_with_playlist)
      expected = %Playlist{name: "foo"}

      assert actual == expected
    end
  end

  test "%Spotify.Playlist{}" do
    attrs = ~w[collaborative description external_urls followers
    href id images name owner public snapshot_id tracks type uri]a

    expected = %Playlist{} |> Map.from_struct |> Map.keys
    assert expected == attrs
  end

  def response_body_with_collection do
    %{
      "playlists" => %{
        "items" => [%{ "name" => "foo" }, %{ "name" => "bar" } ]
      }
    }
  end

  def response_body_with_playlist, do: %{ "name" => "foo" }
end
