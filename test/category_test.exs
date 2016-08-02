defmodule CategoryTest do
  use ExUnit.Case
  alias Spotify.{Category}

  test "%Category{}" do
    expected = ~w[href icons id name]a
    actual = %Category{} |> Map.from_struct |> Map.keys

    assert actual == expected
  end
end
