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

      expected = %Paging{items: [%Track{name: "foo"}, %Track{name: "bar"}]}
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

  defp tracks_response do
    %{
      "items" => [
        %{"track" => %{"name" => "foo"}},
        %{"track" => %{"name" => "bar"}}
      ]
    }
  end
end
