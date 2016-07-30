defmodule PersonalizationTest do
  use ExUnit.Case

  alias Spotify.{Personalization, Artist, Track}

  describe "build_response/1" do
    test "User requests top artists" do
      actual = Personalization.build_response(response_with_artists)
      artists = [%Artist{name: "foo", type: "artist"}, %Artist{name: "bar", type: "artist"}]

      expected = %Paging{items: artists}

      assert actual == expected
    end

    test "User requests top tracks" do
      actual = Personalization.build_response(response_with_tracks)
      tracks = [%Track{name: "foo", type: "track"}, %Track{name: "bar", type: "track"}]
      expected = %Paging{items: tracks}

      assert actual == expected
    end
  end

  test "%Spotify.Personalization{}" do
    attrs = ~w[href items limit next previous total]a

    expected = %Personalization{} |> Map.from_struct |> Map.keys
    assert expected == attrs
  end

  def response_with_artists do
    %{
      "items" => [
        %{ "name" => "foo", "type" => "artist" },
        %{ "name" => "bar", "type" => "artist" }
      ]
    }
  end

  def response_with_tracks do
    %{
      "items" => [
        %{ "name" => "foo", "type" => "track" },
        %{ "name" => "bar", "type" => "track" }
      ]
    }
  end

end
