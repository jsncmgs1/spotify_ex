defmodule SeedTest do
  use ExUnit.Case

  test "%Seed{}" do
    actual = %Spotify.Seed{} |> Map.from_struct |> Map.keys
    expected = ~w[afterFilteringSize afterRelinkingSize href id initialPoolSize type]a

    assert actual == expected
  end
end
