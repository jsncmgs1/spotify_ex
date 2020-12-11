defmodule Spotify.CurrentlyPlaying do
  defstruct ~w[
    actions
    context
    currently_playing_type
    is_playing
    item
    progress_ms
    timestamp
  ]a
end
