defmodule Album do
  use ExUnit.Case

  alias Spotify.{Album, Track}

  test "%Spotify.Album{}" do
    expected = ~w[ album_type artists available_markets copyrights external_ids
      external_urls genres href id images name popularity release_date
      release_date_precision tracks type]a

    actual = %Album{} |> Map.from_struct |> Map.keys
    assert expected == actual
  end

  describe "build_response/1" do
    test "when a collection of albums is requested" do
      actual = Album.build_response(albums_response)
      expected = [ %Album{id: "foo", tracks: %Paging{items: [%Track{name: "foo"}]} } ]

      assert actual == expected
    end

    test "when a single album is requested" do
      actual = Album.build_response(album_response)
      expected = %Album{album_type: "foo", tracks: %Paging{items: [%Track{name: "foo"}]} }

      assert actual == expected

    end

    test "when a collection of tracks is requested" do
      actual = Album.build_response(tracks_response)
      expected = %Paging{items: [%Track{track_number: "foo"}]}

      assert actual == expected
    end
  end

  def tracks_response do
    %{ "items" => [ %{ "track_number" => "foo" } ] }
  end

  def albums_response do
    %{ "albums" => [
        %{
          "id" => "foo",
          "tracks" => %{
            # tracks is a paging object, the actual tracks are in
            # the items key
            "items" => [ %{"name" => "foo"} ]
          }
        }
      ]
    }
  end

  def album_response do
    %{ "album_type" => "foo",
      "tracks" => %{
        # tracks is a paging object, the actual tracks are in
        # the items key
        "items" => [ %{"name" => "foo"} ]
      }
    }
  end

end
