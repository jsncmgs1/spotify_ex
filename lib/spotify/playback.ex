defmodule Spotify.Playback do
  defstruct ~w[
    actions
    context
    currently_playing_type
    device
    is_playing
    item
    progress_ms
    repeat_state
    shuffle_state
    timestamp
  ]a
end
