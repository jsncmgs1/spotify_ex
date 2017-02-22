defmodule Playlist.TrackTest do
  use ExUnit.Case
  alias Spotify.Playlist.Track, as: PT
  alias Spotify.Track

  test "%Spotify.Playlist.Track{}" do
    expected = ~w[added_at added_by is_local track]a
    actual = %PT{} |> Map.from_struct |> Map.keys

    assert actual == expected
  end

  test "build_response/1" do
    actual = PT.build_response(response())

    track = %Track{name: "foo"}
    expected = %Paging{items: [%PT{added_at: "2014-08-18T20:16:08Z", track: track}]}

    assert actual == expected
  end

  def response do
    %{ "items" => [
        %{
          "added_at" => "2014-08-18T20:16:08Z",
          "track" => %{"name" => "foo"}
        }
      ]
    }
  end
end
