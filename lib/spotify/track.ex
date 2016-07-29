defmodule Spotify.Track do
  @moduledoc false
  import Helpers

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

  **Method**: `GET`
  """
  def audio_features(conn, ids) when is_list(ids) do
    url = audio_features_url(ids)
    conn |> Client.get(conn, ids) |> handle_response
  end

  @doc """
  Get audio features for a track

  **Method**: `GET`
  """
  def audio_features(conn, id) do
    url = audio_feature_url(id)
    conn |> Client.get(conn, id) |> handle_response
  end

  @doc """
  Get audio features for several tracks

      iex> Spotify.Track.audio_features_url(ids: "1,3")
      "https://api.spotify.com/v1/audio-features?ids=1%2C3"
  """
  def audio_features_url(ids) do
    "https://api.spotify.com/v1/audio-features" <> query_string(ids)
  end

  @doc """
  Get audio features for a track

      iex> Spotify.Track.audio_feature_url("1")
      "https://api.spotify.com/v1/audio-features/1"
  """
  def audio_feature_url(id) do
    "https://api.spotify.com/v1/audio-features/#{id}"
  end

  @doc """
  Get several tracks

  **Method**: `GET`
  """
  def get_tracks(conn, ids: ids) do

  end

  @doc """
  Get a track

  **Method**: `GET`
  """
  def get_tracks(conn, id) do

  end

  @doc """
  Get several tracks

      iex> Spotify.Track.get_tracks_url(ids: "1,3")
      "https://api.spotify.com/v1/tracks?ids=1%2C3"

  """
  def get_tracks_url(ids) when is_list(ids) do
    "https://api.spotify.com/v1/tracks" <> query_string(ids)
  end

  @doc """
  Get a track

      iex> Spotify.Track.get_track_url("1")
      "https://api.spotify.com/v1/tracks/1"

  """
  def get_track_url(id) do
    "https://api.spotify.com/v1/tracks/#{id}"
  end

  def handle_response({ message, %HTTPoison.Response{ status_code: code, body: body }})
    when code in 400..499 do
      { message, Poison.decode!(body)}
    end

  def handle_response({ :ok, %HTTPoison.Response{ status_code: _code, body: body }}) do
    data = body |> Poison.decode! |> build_response

    { :ok, data }
  end

  def build_response(body) do
    if audio_features = body["audio_features"] do
      audio_features = Enum.map(audio_features, &to_struct(AudioFeatures, &1))
    else
      to_struct(__MODULE__, body)
    end
  end

end
