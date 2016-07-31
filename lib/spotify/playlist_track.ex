defmodule Spotify.Playlist.Track do
  @moduledoc """
  Requesting track info from a specific playlist
  """
  import Helpers
  use Responder
  @behaviour Responder

  defstruct ~w[
    added_at
    added_by
    is_local
    track
  ]a

  @doc """
  Implements the hook expected by the Responder behaviour
  """
  def build_response(body) do
    tracks = body["items"]
    tracks = Enum.map(tracks, fn(track) ->
      track_info = to_struct(__MODULE__, track)
      Map.put(track_info, :track, to_struct(Spotify.Track, track_info.track))
    end)

    Paging.response(body, tracks)
  end
end
