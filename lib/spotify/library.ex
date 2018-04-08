defmodule Spotify.Library do
  @moduledoc """
  Functions for retrieving information about, and managing, tracks that the
  current user has saved in their "Your Music" library. If you are looking
  for functions for retrieving the current user's saved albums, see
  Spotify.Album

  There are two function for each endpoint; one that actually makes the
  request, and one that provides the endpoint:

  Spotify.Library.get_saved_tracks(conn, params) # makes the GET request
  Spotify.Library.get_saved_tracks_url(params) # provides the url for the request

  https://developer.spotify.com/web-api/library-endpoints/
  """

  use Responder
  import Helpers
  alias Spotify.{Client, Track}

  @doc """
  Save one or more tracks to the current user’s library.
  [Spotify Documentation](https://developer.spotify.com/web-api/save-tracks-user/)

  **Method**: PUT

  **Optional Params**:
    * `ids` - A comma-separated string of the Spotify IDs. Maximum: 50 IDs.

      iex> Spotify.Library.save_tracks(conn, ids: "1,4")
      :ok
  """
  def save_tracks(conn, params) do
    url = saved_tracks_url(params)

    conn
    |> Client.put(url)
    |> handle_response
  end

  @doc """
  Get a list of the songs saved in the current user's library.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-saved-tracks/)

  **Method**: GET

  **Optional Params**:
    * `limit` - The maximum number of objects to return. Default: 20.
    Minimum: 1. Maximum: 50
    * `offset` - The index of the first object to return.
    Default: 0 (i.e., the first object). Use with limit to get the next set of objects.
    * `market` - An ISO 3166-1 alpha-2 country code.

      iex> Spotify.Library.get_saved_tracks(conn, limit: "1")
      {:ok, [%Spotify.Track{}]}
  """
  def get_saved_tracks(conn, params \\ []) do
    url = saved_tracks_url(params)

    conn
    |> Client.get(url)
    |> handle_response
  end

  @doc """
  Remove one or more tracks from the current user's library.
  [Spotify Documentation](https://developer.spotify.com/web-api/remove-tracks-user/)

  **Method**: DELETE

  **Optional Params**:
    * `ids` - A comma-separated string of the Spotify IDs. Maximum: 50 IDs.

    iex> Spotify.Library.remove_saved_tracks(conn, ids: "1,4")
    :ok
  """
  def remove_saved_tracks(conn, params \\ []) do
    url = saved_tracks_url(params)

    conn
    |> Client.delete(url)
    |> handle_response
  end

  @doc """
  Get url for saved tracks in the current user’s library.

      iex> Spotify.Library.save_tracks_url(ids: "1,4")
      "https://api.spotify.com/v1/me/tracks?ids=1%2C4"
  """
  def saved_tracks_url(params) do
    "https://api.spotify.com/v1/me/tracks" <> query_string(params)
  end

  @doc """
  Check if one or more tracks is already saved in the current user’s library.

  **Method**: GET

  **Optional Params**:
    * `ids` - A comma-separated string of the Spotify IDs. Maximum: 50 IDs.

    iex> Spotify.Library.check_saved_tracks(conn, ids: "1,4")
    {:ok, [true, false]}
  """
  def check_saved_tracks(conn, params) do
    url = check_saved_tracks_url(params)

    conn
    |> Client.get(url)
    |> handle_response
  end

  @doc """
  Get url to check if one or more tracks is already saved in the current user’s library.

    iex> Spotify.Library.check_saved_tracks_url(id: "1,4")
    "https://api.spotify.com/v1/me/tracks/contains?ids=1%2C4"
  """
  def check_saved_tracks_url(params) do
    "https://api.spotify.com/v1/me/tracks/contains" <> query_string(params)
  end

  @doc """
  Implement the callback required by the `Responder` behavior
  """
  def build_response(body) do
    case body do
      %{"items" => tracks} -> build_tracks(tracks)
      booleans_or_error -> booleans_or_error
    end
  end

  def build_tracks(tracks) do
    tracks = Enum.map(tracks, fn %{"track" => items} -> items end)
    tracks = Track.build_tracks(tracks)
    %Paging{items: tracks}
  end
end
