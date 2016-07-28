defmodule Spotify.Playlist.Track do
  import Helpers

  defstruct ~w[
    added_at
    added_by
    is_local
    track
  ]a

  def build_response(body) do
    tracks = body["items"]
    tracks = Enum.map(tracks, fn(track) ->
      track_info = to_struct(__MODULE__, track)
      track = Map.update(track_info, :track, to_struct(Spotify.Track, track_info.track))
    end)

    Paging.response(body, tracks)
  end
end
