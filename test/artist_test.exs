defmodule ArtistTest do
  use ExUnit.Case
  alias Spotify.{Artist, Track}

  test "%Spotify.Artist{}" do
    expected = ~w[external_urls followers genres href id images name popularity type uri]a
    actual = %Artist{} |> Map.from_struct |> Map.keys

    assert actual == expected
  end

  describe "build_response/1" do
    test "it returns a collection of artists" do
      expected = [%Artist{name: "foo"}, %Artist{name: "bar"}]
      actual = Spotify.Artist.build_response(artists_response())

      assert actual == expected
    end

    test "it returns an artist" do
      response = %{"name" => "foo"}
      expected = %Artist{name: "foo"}
      actual = Spotify.Artist.build_response(response)

      assert actual == expected
    end

    test "it returns booleans" do
      response = [ true, false ]
      expected = [ true, false ]
      actual = Spotify.Artist.build_response(response)

      assert actual == expected
    end

    test "it returns tracks" do
      expected = [%Track{name: "foo"}, %Track{name: "bar"}]
      actual = Spotify.Artist.build_response(tracks_response())

      assert actual == expected
    end
  end

  def artists_response do
    %{ "artists" =>
        [
          %{ "name" => "foo" },
          %{ "name" => "bar" },
        ]
    }
  end

  def tracks_response do
    %{ "tracks" =>
        [
          %{ "name" => "foo" },
          %{ "name" => "bar" },
        ]
    }
  end
end
