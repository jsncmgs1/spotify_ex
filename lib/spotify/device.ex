defmodule Spotify.Device do
  defstruct ~w[
    id
    is_active
    is_private_session
    is_restricted
    name
    type
    volume_percent
  ]a
end
