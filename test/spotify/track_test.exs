defmodule Spotify.TrackTest do
  use ExUnit.Case
  alias Spotify.Track

  test "%Spotify.Track{}" do
    attrs =
      ~w[album artists available_markets disc_number duration_ms explicit external_ids href id is_playable linked_from name popularity preview_url track_number type uri]a

    expected = %Track{} |> Map.from_struct() |> Map.keys()
    assert expected == attrs
  end

  describe "build_response/1 when audio features are requested" do
    test "API returns a single item" do
      response = %{"album" => "foo"}

      expected = %Track{album: "foo"}
      actual = Track.build_response(response)

      assert expected == actual
    end

    test "API returns a collection" do
      response = %{"tracks" => [%{"album" => "foo"}, %{"album" => "bar"}]}

      expected = [%Track{album: "foo"}, %Track{album: "bar"}]
      actual = Track.build_response(response)

      assert expected == actual
    end
  end

  describe "build_response/1 when tracks are requested" do
    test "API returns a single item" do
      response = %{"energy" => "foo"}
      expected = %Spotify.AudioFeatures{energy: "foo"}
      actual = Track.build_response(response)

      assert expected == actual
    end

    test "API returns a collection" do
      response = %{"audio_features" => [%{"energy" => "foo"}, %{"energy" => "bar"}]}
      expected = [%Spotify.AudioFeatures{energy: "foo"}, %Spotify.AudioFeatures{energy: "bar"}]
      actual = Track.build_response(response)

      assert expected == actual
    end
  end
end
