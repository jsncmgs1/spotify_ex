defmodule Spotify.Album do
  @moduledoc false

  @doc false
  defstruct ~w[
    album_type artists available_markets
    copyrights external_ids external_urls
    genres href id images name popularity
    release_date release_date_precision tracks type]a

  use Responder
  @behaviour Responder

  @doc """
  GET
  /v1/albums/{id} Get an album  album
  """
  def get_album do

  end

  @doc """
  GET /v1/albums?ids={ids}
  Get several albums  albums
  """
  def get_albums do

  end

  @doc """
  GET /v1/albums/{id}/tracks  Get an album's tracks tracks*
  """
  def get_albums_tracks do

  end

  @doc """
  GET /v1/artists/{id}/albums Get an artist's albums  albums*
  """
  def get_artists_albums do

  end

  @doc """
  GET /v1/browse/new-releases Get a list of new releases  albums* OAuth
  """
  def get_new_releases do

  end

  @doc """
  PUT /v1/me/albums?ids={ids}
  Save albums for user  - OAuth
  """
  def save_albums do

  end

  @doc """
  GET /v1/me/albums
  Get user's saved albums saved albums  OAuth
  """

  def my_albums do

  end

  @doc """
  DELETE  /v1/me/albums?ids={ids} Remove user's saved albums  - OAuth
  """
  def remove_albums do

  end

  @doc """
  GET /v1/me/albums/contains?ids={ids}
  Check user's saved albums true/false  OAuth
  """
  def check_album do

  end

  @doc """
  GET /v1/search?type=album Search for an album albums*
  """
  def search do

  end

  def build_response(body) do

  end
end
