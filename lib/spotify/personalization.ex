defmodule Spotify.Personalization do
  import Helpers
  alias Spotify.Client

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

  @doc """
  Get the current user’s top artists based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

      Spotify.Personalization.top_artists!
      %HTTPoison.Response{..}

      iex> Spotify.Personalization.top_artists
      "https://api.spotify.com/v1/me/top/artists"

      iex> Spotify.Personalization.top_artists(limit: 5, time_range: "medium_term")
      "https://api.spotify.com/v1/me/top/artists?limit=5&time_range=medium_term"

  """
  def top_artists(params \\ []) do
    url <> "artists" <> query_string(params)
  end

  def top_artists!(params \\ []) do
    Client.get(top_artists(params))
  end

  @doc """
  Get the current user’s top tracks based on calculated affinity.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-top-artists-and-tracks/)

  **Method**: `GET`

  **Optional Params**: `limit`, `offset`, `time_range`

      Spotify.Personalization.top_tracks!
      %HTTPoison.Response{..}

      iex> Spotify.Personalization.top_tracks
      "https://api.spotify.com/v1/me/top/tracks"

      iex> Spotify.Personalization.top_tracks(limit: 5, time_range: "medium_term")
      "https://api.spotify.com/v1/me/top/tracks?limit=5&time_range=medium_term"
  """
  def top_tracks(params \\ []) do
    url <> "tracks" <> query_string(params)
  end

  def top_tracks!(params \\ []) do
    Client.get(top_tracks(params))
  end

  def url do
    "https://api.spotify.com/v1/me/top/"
  end

end
