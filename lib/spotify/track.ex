defmodule Spotify.Track do
  import Helpers

  defstruct ~w[
    album
    artists
    available_markets
    disc_number
    duration_ms
    explicit
    external_ids
    href
    id
    is_playable
    linked_from
    name
    popularity
    preview_url
    track_number
    type
    uri
  ]a
end
