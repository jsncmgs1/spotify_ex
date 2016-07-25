defmodule Spotify.Personalization do
  import Helpers

  @moduledoc """
  Endpoints for retrieving information about the user’s listening habits

  Each endpoint has a function which returns the endpoint URL, and a
  bang version which makes the request and returns a `HTTPoison.Response` struct.

  Spotify.Playlist.featured!(country: "US")
  # => %HTTPoison.Response{...}

  Spotify.Playlist.featured
  # => "https://api.spotify.com/v1/browse/featured-playlists"

  https://developer.spotify.com/web-api/web-api-personalization-endpoints/
  """

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
  %HTTPoison.Response{..}

  iex> Spotify.Personalization.top_artists_url(limit: 5, time_range: "medium_term")
  "https://api.spotify.com/v1/me/top/artists?limit=5&time_range=medium_term"

  """
  def top_artists(conn, params \\ []) do
    foo = send_request Client.get(conn, top_artists_url(params))
  end

  def top_artists_url(params \\ []) do
    url <> "artists" <> query_string(params)
  end

  @doc """
  Get the current user’s top tracks based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

  Spotify.Personalization.top_tracks(conn)
  %HTTPoison.Response{..}

  iex> Spotify.Personalization.top_tracks_url
  "https://api.spotify.com/v1/me/top/tracks"
  """
  def top_tracks(conn, params \\ []) do
    send_request Client.get(conn, top_tracks_url(params))
  end

  def top_tracks_url(params \\ []) do
    url <> "tracks" <> query_string(params)
  end

  def url do
    "https://api.spotify.com/v1/me/top/"
  end

end
