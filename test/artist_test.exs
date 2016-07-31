defmodule ArtistTest do
  use ExUnit.Case
  alias Spotify.Artist

  test "%Spotify.Artist{}" do
    attrs = ~w[external_urls followers genres href id images name popularity type uri]a
    expected = %Artist{} |> Map.from_struct |> Map.keys
    assert expected == attrs
  end
end
