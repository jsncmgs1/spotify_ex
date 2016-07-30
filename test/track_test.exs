defmodule TrackTest do
  use ExUnit.Case
  alias Spotify.Track

  test "%Spotify.Track{}" do
    attrs = ~w[album artists available_markets disc_number duration_ms explicit external_ids href id is_playable linked_from name popularity preview_url track_number type uri]a

    expected = %Track{} |> Map.from_struct |> Map.keys
    assert expected == attrs
  end
end
