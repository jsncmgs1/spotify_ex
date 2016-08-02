defmodule Spotify.Artist do
  @moduledoc false

  import Helpers
  use Responder
  @behaviour Responder
  alias Spotify.Client

  defstruct ~w[
    external_urls
    followers
    genres
    href
    id
    images
    name
    popularity
    type
    uri
  ]a

  @doc """
  Get Spotify catalog information for a single artist identified by their unique Spotify ID.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-artist/)

  **Method**: `GET`
  """
  def get_artist(conn, id) do

  end

  def get_artist_url(id) do
    "https://api.spotify.com/v1/artists/#{id}"
  end

  @doc """
  Get Spotify catalog information for several artists based on their Spotify IDs.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-several-artists/)

  **Method**: `GET`

  **Required Params**: `ids`
  """
  def get_artists(conn, params) do

  end

  @doc """
  Get Spotify catalog information about an artist’s albums.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-artists-albums/)

  **Method**: `GET`

  **Optional Params**: `market`, `album_type`, `offset`, `limit`
  """
  def get_artists_albums(conn, id, params \\ []) do

  end

  def get_artists_albums_url(id, params) do
    "https://api.spotify.com/v1/artists/#{id}/albums" <> query_string(params)
  end

  @doc """
  Get Spotify catalog information about an artist’s top tracks by country.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-artists-top-tracks/)

  **Method**: `GET`

  **Required Params**: `country`
  """
  def get_top_tracks(conn, id, params) do

  end

  def get_top_tracks_url(id, params) do
    "https://api.spotify.com/v1/artists/#{id}/top-tracks" <> query_string(params)
  end

  @doc """
  ** Method **: `GET`
  """
  def get_related_artists(conn, id) do

  end

  @doc """
  ** Method **: `GET`
  """
  def my_following(conn) do

  end

  @doc """
  ** Method **: `PUT`
  """
  def follow(conn, params) do

  end

  @doc """
  ** Method **: `DELETE`
  """
  def unfollow(conn, params) do

  end

  @doc """
  ** Method **: `GET`
  """
  def check_following(conn, params) do

  end

  @doc """
  ** Method **: `GET`
  """
  def my_top_tracks(conn) do

  end

  @doc """
  ** Method **: `GET`
  """
  def my_top_artists(conn) do

  end

  @doc """
  ** Method **: `GET`
  """
  def search(conn, params) do

  end

  def build_response(body) do

  end

end
