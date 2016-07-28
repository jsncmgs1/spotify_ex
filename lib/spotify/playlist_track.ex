defmodule Spotify.Playlist.Track do
  @moduledoc """
  Requesting track info from a specific playkist
  """
  import Helpers

  defstruct ~w[
    added_at
    added_by
    is_local
    track
  ]a

  def handle_response({ message, %HTTPoison.Response{ status_code: code, body: body }})
    when code in 400..499 do
      { message, body }
    end

  @doc false

  def handle_response({ :ok, %HTTPoison.Response{ status_code: _code, body: body }}) do
    body |> Poison.decode! |> build_response
  end

  def build_response(body) do
    tracks = body["items"]
    tracks = Enum.map(tracks, fn(track) ->
      track_info = to_struct(__MODULE__, track)
      Map.put(track_info, :track, to_struct(Spotify.Track, track_info.track))
    end)

    Paging.response(body, tracks)
  end
end
