defmodule Spotify.LibraryTest do
  use ExUnit.Case

  alias Spotify.{
    Library,
    Paging,
    Track
  }

  describe "build_response/1 when body contains a list of tracks" do
    test "returns a collection of Spotify.Tracks" do
      response = tracks_response()

      expected = %Paging{
        href: "https://api.spotify.com/v1/me/tracks?offset=0&limit=20",
        items: [%Track{name: "foo"}, %Track{name: "bar"}],
        limit: 20,
        next: "https://api.spotify.com/v1/me/tracks?offset=20&limit=20",
        offset: 0,
        previous: nil,
        total: 62
      }

      actual = Library.build_response(response)

      assert actual == expected
    end
  end

  describe "build_response/1 when body is a list of booleans" do
    test "returns a list of booleans" do
      expected = [false, false]
      actual = Library.build_response([false, false])

      assert actual == expected
    end
  end

  def tracks_response do
    %{
      "href" => "https://api.spotify.com/v1/me/tracks?offset=0&limit=20",
      "items" => [
        %{"track" => %{"name" => "foo"}},
        %{"track" => %{"name" => "bar"}}
      ],
      "limit" => 20,
      "next" => "https://api.spotify.com/v1/me/tracks?offset=20&limit=20",
      "offset" => 0,
      "previous" => nil,
      "total" => 62
    }
  end
end
