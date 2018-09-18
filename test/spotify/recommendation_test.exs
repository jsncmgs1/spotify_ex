defmodule Spotify.RecommendationTest do
  use ExUnit.Case

  alias Spotify.{
    Recommendation,
    Seed,
    Track
  }

  test "%Recommendation{}" do
    actual = %Recommendation{} |> Map.from_struct() |> Map.keys()
    expected = ~w[seeds tracks]a

    assert actual == expected
  end

  test "build_response/1" do
    response = %{"seeds" => [%{"id" => "foo"}], "tracks" => [%{"id" => "bar"}]}
    actual = Recommendation.build_response(response)
    expected = %Recommendation{tracks: [%Track{id: "bar"}], seeds: [%Seed{id: "foo"}]}

    assert actual == expected
  end
end
