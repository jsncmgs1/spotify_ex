defmodule ProfileTest do
  use ExUnit.Case

  alias Spotify.Profile

  test "%Spotify.Profile{}" do
    actual = ~w[birthdate country display_name email external_urls followers href id images product type uri]a
    expected = %Profile{} |> Map.from_struct |> Map.keys

    assert actual == expected
  end

  test "build_response/1" do
    response = %{ "display_name" => "foo" }
    actual = Profile.build_response(response)
    expected = %Profile{display_name: "foo"}

    assert actual == expected
  end
end
