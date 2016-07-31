defmodule Playlist.TrackTest do
  use ExUnit.Case
  alias Spotify.Playlist.Track, as: PT
  alias Spotify.Track

  test "%Spotify.Playlist.Track{}" do
    attrs = ~w[added_at added_by is_local track]a
    expected = %PT{} |> Map.from_struct |> Map.keys

    assert attrs = expected
  end

  test "handle_response/1" do
    actual = PT.build_response(response)

    tracks = [ %Track{name: "foo"} ]
    expected = %Paging{items: [%PT{track: tracks}]}

    assert actual = expected
  end

  def response do
    %{ "items" => [
        %{ "track" => %Track{name: "foo"} }
      ]
    }
  end
end
