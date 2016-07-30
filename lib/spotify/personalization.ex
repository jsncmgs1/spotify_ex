defmodule Spotify.Personalization do
  @moduledoc """
  Endpoints for retrieving information about the user’s listening habits

  Some endpoints return collections. Spotify wraps the collection in a paging object,
  this API does the same. A single piece of data will not be wrapped.

  There are two functions for each endpoint, one that actually makes the request,
  and one that provides the endpoint:

        Spotify.Playist.create_playlist(conn, "foo", "bar") # makes the POST request.
        Spotify.Playist.create_playlist_url("foo", "bar") # provides the url for the request.

  https://developer.spotify.com/web-api/web-api-personalization-endpoints/
  """

  import Helpers
  use Responder
  @behaviour Responder
  alias Spotify.Client

  @doc """
  Defines the Personalization struct.
  """
  defstruct ~w[ items next previous total limit href ]a

  @doc """
  Get the current user’s top artists based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

      Spotify.Personalization.top_artists(conn)
      { :ok, artists: [%Spotify.Artist{..}...], paging: %Paging{next:...} }
  """
  def top_artists(conn, params \\ []) do

    url = top_artists_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get the current user’s top artists based on calculated affinity.

      iex> Spotify.Personalization.top_artists_url(limit: 5, time_range: "medium_term")
      "https://api.spotify.com/v1/me/top/artists?limit=5&time_range=medium_term"
  """
  def top_artists_url(params \\ []) do
    url <> "artists" <> query_string(params)
  end

  @doc """
  Get the current user’s top tracks based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

      Spotify.Personalization.top_tracks(conn)
      { :ok, tracks: [%Spotify.Tracks{..}...], paging: %Paging{next:...} }

  """
  def top_tracks(conn, params \\ []) do
    url = top_tracks_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get the current user’s top tracks based on calculated affinity.

      iex> Spotify.Personalization.top_tracks_url
      "https://api.spotify.com/v1/me/top/tracks"
  """
  def top_tracks_url(params \\ []) do
    url <> "tracks" <> query_string(params)
  end

  @doc """
  Base URL
  """
  def url do
    "https://api.spotify.com/v1/me/top/"
  end

  @doc """
  Implements the hook expected by the Responder behaviour
  """
  def build_response(body) do
    items = Enum.map(body["items"], fn(item) ->
      case item["type"] do
        "artist" -> build_artist_struct(item)
        "track"  -> build_track_struct(item)
      end
    end)

    paging = to_struct(Paging, body)
     Map.put(paging, :items, items)
  end

  @doc false
  def build_artist_struct(artist) do
    to_struct(Spotify.Artist, artist)
  end

  @doc false
  def build_track_struct(track) do
    to_struct(Spotify.Track, track)
  end

end
