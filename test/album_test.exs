defmodule Spotify.Album do
  use ExUnit.Case
  alias Spotify.Album

  test "%Spotify.Album{}" do
    expected = ~w[ album_type artists available_markets copyrights external_ids
      external_urls genres href id images name popularity release_date
      release_date_precision tracks type]a

    actual = %Album{} |> Map.from_struct |> Map.keys
    assert expected == actual
  end
end
