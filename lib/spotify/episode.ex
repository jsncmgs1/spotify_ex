defmodule Spotify.Episode do
  defstruct ~w[
    audio_preview_url
    description
    duration_ms
    explicit
    external_urls
    href
    id
    images
    is_externally_hosted
    is_playable
    language
    languages
    name
    release_date
    release_date_precision
    resume_point
    show
    type
    uri
  ]a
end
