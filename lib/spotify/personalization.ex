defmodule Spotify.Personalization do
  import Helpers

  @moduledoc """
  Endpoints for retrieving information about the user’s listening habits

  https://developer.spotify.com/web-api/web-api-personalization-endpoints/
  """

  @doc """
  Get the current user’s top artists based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

      iex> Spotify.Personalization.top_artists
      "https://api.spotify.com/v1/me/top/artists"

      iex> Spotify.Personalization.top_artists(limit: 5, time_range: "medium_term")
      "https://api.spotify.com/v1/me/top/artists?limit=5&time_range=medium_term"

  """
  def top_artists(params \\ []) do
    url <> "artists" <> query_string(params)
  end

  @doc """
  Get the current user’s top tracks based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

      iex> Spotify.Personalization.top_tracks
      "https://api.spotify.com/v1/me/top/tracks"

      iex> Spotify.Personalization.top_tracks(limit: 5, time_range: "medium_term")
      "https://api.spotify.com/v1/me/top/tracks?limit=5&time_range=medium_term"
  """
  def top_tracks(params \\ []) do
    url <> "tracks" <> query_string(params)
  end

  def url do
    "https://api.spotify.com/v1/me/top/"
  end

end
