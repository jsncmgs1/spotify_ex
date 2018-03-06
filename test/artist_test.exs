defmodule ArtistTest do
  use ExUnit.Case
  alias Spotify.{Artist, Track}

  test "%Spotify.Artist{}" do
    expected = ~w[external_urls followers genres href id images name popularity type uri]a
    actual = %Artist{} |> Map.from_struct() |> Map.keys()

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
      response = [true, false]
      expected = [true, false]
      actual = Spotify.Artist.build_response(response)

      assert actual == expected
    end

    test "it returns tracks" do
      expected = [%Track{name: "foo"}, %Track{name: "bar"}]
      actual = Spotify.Artist.build_response(tracks_response())

      assert actual == expected
    end

    test "it returns a paged struct" do
      expected = %Paging{
        items: [
          %Artist{
            external_urls: %{
              "spotify" => "https://open.spotify.com/artist/5dg3YtsiR8ux6amJv9m9AG"
            },
            followers: %{"href" => nil, "total" => 12336},
            genres: [
              "europop",
              "swedish alternative rock",
              "swedish idol pop",
              "swedish pop"
            ],
            href: "https://api.spotify.com/v1/artists/5dg3YtsiR8ux6amJv9m9AG",
            id: "5dg3YtsiR8ux6amJv9m9AG",
            images: [
              %{
                "height" => 640,
                "url" => "https://i.scdn.co/image/d1e83fee8c4aa5396a9d263a679b6d8e280fa53a",
                "width" => 640
              }
            ],
            name: "Erik Grönwall",
            popularity: 41,
            type: "artist",
            uri: "spotify:artist:5dg3YtsiR8ux6amJv9m9AG"
          }
        ],
        next: nil,
        total: 5,
        cursors: %{"after" => nil},
        limit: 50,
        href: "https://api.spotify.com/v1/me/following?type=artist&limit=50"
      }

      actual = Spotify.Artist.build_response(artist_response_with_pagination())
      assert actual == expected
    end
  end

  def artist_response_with_pagination do
    %{
      "artists" => %{
        "items" => [
          %{
            "external_urls" => %{
              "spotify" => "https://open.spotify.com/artist/5dg3YtsiR8ux6amJv9m9AG"
            },
            "followers" => %{
              "href" => nil,
              "total" => 12336
            },
            "genres" => [
              "europop",
              "swedish alternative rock",
              "swedish idol pop",
              "swedish pop"
            ],
            "href" => "https://api.spotify.com/v1/artists/5dg3YtsiR8ux6amJv9m9AG",
            "id" => "5dg3YtsiR8ux6amJv9m9AG",
            "images" => [
              %{
                "height" => 640,
                "url" => "https://i.scdn.co/image/d1e83fee8c4aa5396a9d263a679b6d8e280fa53a",
                "width" => 640
              }
            ],
            "name" => "Erik Grönwall",
            "popularity" => 41,
            "type" => "artist",
            "uri" => "spotify:artist:5dg3YtsiR8ux6amJv9m9AG"
          }
        ],
        "next" => nil,
        "total" => 5,
        "cursors" => %{
          "after" => nil
        },
        "limit" => 50,
        "href" => "https://api.spotify.com/v1/me/following?type=artist&limit=50"
      }
    }
  end

  def artists_response do
    %{
      "artists" => [
        %{"name" => "foo"},
        %{"name" => "bar"}
      ]
    }
  end

  def tracks_response do
    %{
      "tracks" => [
        %{"name" => "foo"},
        %{"name" => "bar"}
      ]
    }
  end
end
