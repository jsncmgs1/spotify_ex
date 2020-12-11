defmodule Spotify.PlayerTest do
  use ExUnit.Case

  alias Spotify.{
    Context,
    Device,
    Episode,
    Player,
    Track
  }

  describe "build_response/1" do
    test "build item struct depending on currently_playing_type" do
      assert %Player{item: %Track{}} = Player.build_response(playback_track_response())
      assert %Player{item: %Episode{}} = Player.build_response(playback_episode_response())
    end

    test "build device struct" do
      assert %Player{device: %Device{}} = Player.build_response(playback_track_response())
    end

    test "build context struct" do
      assert %Player{context: %Context{}} = Player.build_response(playback_track_response())
    end
  end

  defp playback_track_response do
    %{
      "actions" => %{"disallows" => %{"resuming" => true}},
      "context" => %{
        "external_urls" => %{
          "spotify" => "https://open.spotify.com/album/ALBUM_ID"
        },
        "href" => "https://api.spotify.com/v1/albums/ALBUM_ID",
        "type" => "album",
        "uri" => "spotify:album:ALBUM_ID"
      },
      "currently_playing_type" => "track",
      "device" => %{
        "id" => "DEVICE_ID",
        "is_active" => true,
        "is_private_session" => false,
        "is_restricted" => false,
        "name" => "Web Player (Chrome)",
        "type" => "Computer",
        "volume_percent" => 35
      },
      "is_playing" => true,
      "item" => %{
        "album" => %{
          "album_type" => "album",
          "artists" => [
            %{
              "external_urls" => %{
                "spotify" => "https://open.spotify.com/artist/ARTIST_ID"
              },
              "href" => "https://api.spotify.com/v1/artists/ARTIST_ID",
              "id" => "ARTIST_ID",
              "name" => "Artist Name",
              "type" => "artist",
              "uri" => "spotify:artist:ARTIST_ID"
            }
          ],
          "available_markets" => ["US"],
          "external_urls" => %{
            "spotify" => "https://open.spotify.com/album/ALBUM_ID"
          },
          "href" => "https://api.spotify.com/v1/albums/ALBUM_ID",
          "id" => "ALBUM_ID",
          "images" => [
            %{
              "height" => 640,
              "url" => "https://i.scdn.co/image/...",
              "width" => 640
            },
            %{
              "height" => 300,
              "url" => "https://i.scdn.co/image/...",
              "width" => 300
            },
            %{
              "height" => 64,
              "url" => "https://i.scdn.co/image/...",
              "width" => 64
            }
          ],
          "name" => "Artist Name",
          "release_date" => "2015-04-07",
          "release_date_precision" => "day",
          "total_tracks" => 23,
          "type" => "album",
          "uri" => "spotify:album:ALBUM_ID"
        },
        "artists" => [
          %{
            "external_urls" => %{
              "spotify" => "https://open.spotify.com/artist/ARTIST_ID"
            },
            "href" => "https://api.spotify.com/v1/artists/ARTIST_ID",
            "id" => "ARTIST_ID",
            "name" => "Artist Name",
            "type" => "artist",
            "uri" => "spotify:artist:ARTIST_ID"
          }
        ],
        "available_markets" => ["US"],
        "disc_number" => 1,
        "duration_ms" => 196_013,
        "explicit" => false,
        "external_ids" => %{"isrc" => "ISRC"},
        "external_urls" => %{
          "spotify" => "https://open.spotify.com/track/TRACK_ID"
        },
        "href" => "https://api.spotify.com/v1/tracks/TRACK_ID",
        "id" => "TRACK_ID",
        "is_local" => false,
        "name" => "Track Name",
        "popularity" => 37,
        "preview_url" => "https://p.scdn.co/mp3-preview/...",
        "track_number" => 1,
        "type" => "track",
        "uri" => "spotify:track:TRACK_ID"
      },
      "progress_ms" => 45646,
      "repeat_state" => "context",
      "shuffle_state" => false,
      "timestamp" => 1_607_682_100_329
    }
  end

  defp playback_episode_response do
    %{
      "actions" => %{"disallows" => %{"resuming" => true}},
      "context" => nil,
      "currently_playing_type" => "episode",
      "device" => %{
        "id" => "DEVICE_ID",
        "is_active" => true,
        "is_private_session" => false,
        "is_restricted" => false,
        "name" => "Web Player (Chrome)",
        "type" => "Computer",
        "volume_percent" => 35
      },
      "is_playing" => true,
      "item" => %{
        "audio_preview_url" => "https://p.scdn.co/mp3-preview/...",
        "description" => "",
        "duration_ms" => 2_685_023,
        "explicit" => false,
        "external_urls" => %{
          "spotify" => "https://open.spotify.com/episode/EPISODE_ID"
        },
        "href" => "https://api.spotify.com/v1/episodes/EPISODE_ID",
        "id" => "EPISODE_ID",
        "images" => [
          %{
            "height" => 640,
            "url" => "https://i.scdn.co/image/...",
            "width" => 640
          },
          %{
            "height" => 300,
            "url" => "https://i.scdn.co/image/...",
            "width" => 300
          },
          %{
            "height" => 64,
            "url" => "https://i.scdn.co/image/...",
            "width" => 64
          }
        ],
        "is_externally_hosted" => false,
        "is_playable" => true,
        "language" => "sv",
        "languages" => ["sv"],
        "name" => "Episode Name",
        "release_date" => "2019-09-10",
        "release_date_precision" => "day",
        "resume_point" => %{
          "fully_played" => false,
          "resume_position_ms" => 0
        },
        "show" => %{
          "available_markets" => ["US"],
          "copyrights" => [],
          "description" => "",
          "explicit" => false,
          "external_urls" => %{
            "spotify" => "https://open.spotify.com/show/SHOW_ID"
          },
          "href" => "https://api.spotify.com/v1/shows/SHOW_ID",
          "id" => "SHOW_ID",
          "images" => [
            %{
              "height" => 640,
              "url" => "https://i.scdn.co/image/...",
              "width" => 640
            },
            %{
              "height" => 300,
              "url" => "https://i.scdn.co/image/...",
              "width" => 300
            },
            %{
              "height" => 64,
              "url" => "https://i.scdn.co/image/...",
              "width" => 64
            }
          ],
          "is_externally_hosted" => false,
          "languages" => ["sv"],
          "media_type" => "audio",
          "name" => "Show Name",
          "publisher" => "Publisher",
          "total_episodes" => 500,
          "type" => "show",
          "uri" => "spotify:show:SHOW_ID"
        },
        "type" => "episode",
        "uri" => "spotify:episode:EPISODE_ID"
      },
      "progress_ms" => 1_479_096,
      "repeat_state" => "context",
      "shuffle_state" => false,
      "timestamp" => 1_607_685_202_846
    }
  end
end
