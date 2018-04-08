defmodule Spotify.Track do
  @moduledoc """
  Functions for retrieving information about one or more tracks.

  There are two functions for each endpoint; one that actually makes the
  request, and one that provides the endpoint:

      Spotify.Track.audio_features(conn, ids: "1, 3") # makes the GET request
      Spotify.Track.audio_features_url(ids: "1, 3") # provides the url for the request

  https://developer.spotify.com/web-api/track-endpoints/
  """

  alias Spotify.{Track, Client}
  import Helpers
  use Responder

  defstruct ~w[
    album
    artists
    available_markets
    disc_number
    duration_ms
    explicit
    external_ids
    href
    id
    is_playable
    linked_from
    name
    popularity
    preview_url
    track_number
    type
    uri
  ]a

  @doc """
  Get audio features for several tracks
  [Spotify Documentation](https://developer.spotify.com/web-api/get-several-audio-features/)

  **Method**: `GET`

      Spotify.Track.audio_features(conn, ids: "1, 3")
      # => {:ok [%Spotify.AudioFeatures, ...]}
  """
  def audio_features(conn, params) when is_list(params) do
    url = audio_features_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get audio features for a track
  [Spotify Documentation](https://developer.spotify.com/web-api/get-audio-features/)

  **Method**: `GET`

      Spotify.Track.audio_features(conn, "1")
      # => {:ok ,%Spotify.AudioFeatures{}}

  """
  def audio_features(conn, id) do
    url = audio_features_url(id)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get audio features for several tracks

      iex> Spotify.Track.audio_features_url(ids: "1,3")
      "https://api.spotify.com/v1/audio-features?ids=1%2C3"
  """
  def audio_features_url(params) when is_list(params) do
    "https://api.spotify.com/v1/audio-features" <> query_string(params)
  end

  @doc """
  Get audio features for a track

      iex> Spotify.Track.audio_features_url("1")
      "https://api.spotify.com/v1/audio-features/1"
  """
  def audio_features_url(id) do
    "https://api.spotify.com/v1/audio-features/#{id}"
  end

  @doc """
  Get several tracks
  [Spotify Documentation](https://developer.spotify.com/web-api/get-several-tracks/)

      Spotify.Track.get_tracks(conn, ids: "1,3")
      # => { :ok , [%Spotify.Track{}, ...] }
  **Method**: `GET`
  """
  def get_tracks(conn, params) do
    url = get_tracks_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get a track
  [Spotify Documentation](https://developer.spotify.com/web-api/get-track/)

  **Method**: `GET`

  **Optional Params**: `market`

      Spotify.get_track(conn, id)
      # => { :ok , %Spotify.Track{} }

  """
  def get_track(conn, id) do
    url = get_track_url(id)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get several tracks

      iex> Spotify.Track.get_tracks_url(ids: "1,3")
      "https://api.spotify.com/v1/tracks?ids=1%2C3"

  """
  def get_tracks_url(params) do
    "https://api.spotify.com/v1/tracks" <> query_string(params)
  end

  @doc """
  Get a track

      iex> Spotify.Track.get_track_url("1")
      "https://api.spotify.com/v1/tracks/1"

  """
  def get_track_url(id) do
    "https://api.spotify.com/v1/tracks/#{id}"
  end

  @doc """
  Implements the hook expected by the Responder behaviour
  """
  def build_response(body) do
    case body do
      %{"audio_features" => audio_features} -> build_audio_features(audio_features)
      %{"tracks" => tracks} -> build_tracks(tracks)
      %{"album" => _} -> to_struct(Track, body)
      %{"energy" => _} -> to_struct(AudioFeatures, body)
    end
  end

  @doc false
  def build_tracks(tracks) do
    Enum.map(tracks, &to_struct(Track, &1))
  end

  @doc false
  def build_audio_features(audio_features) do
    Enum.map(audio_features, &to_struct(AudioFeatures, &1))
  end
end
