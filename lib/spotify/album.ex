defmodule Spotify.Album do
  @moduledoc """
    Functions for retrieving information about albums.

    Some endpoints return collections. Spotify wraps the collection in a paging object,
    this API does the same. A single piece of data will not be wrapped, however
    in some instances an objet key can contain a collection wrapped in a paging
    object, for example, requesting several albums will not give you a paging
    object for the albums, but the tracks will be wrapped in one.

    There are two functions for each endpoint, one that actually makes the request,
    and one that provides the endpoint:

        Spotify.Playist.create_playlist(conn, "foo", "bar") # makes the POST request.
        Spotify.Playist.create_playlist_url("foo", "bar") # provides the url for the request.

  https://developer.spotify.com/web-api/get-several-albums/
  """

  use Responder
  import Helpers
  alias Spotify.{Client, Album, Track}

  defstruct ~w[
    album_type artists available_markets
    copyrights external_ids external_urls
    genres href id images name popularity
    release_date release_date_precision tracks type label]a

  @doc """
  Get Spotify catalog information for a single album.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-album/)

  **Method**: GET

  **Optional Params**: `market`

      Spotify.Album.get_album(conn, "4")
      # => { :ok, %Spotify.Album{...} }
  """
  def get_album(conn, id, params \\ []) do
    url = get_album_url(id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information for a single album.

      iex> Spotify.Album.get_album_url("4")
      "https://api.spotify.com/v1/albums/4"
  """
  def get_album_url(id, params \\ []) do
    "https://api.spotify.com/v1/albums/#{id}" <> query_string(params)
  end

  @doc """
  Get Spotify catalog information for multiple albums identified by their Spotify IDs.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-several-albums/)

  **Method**: GET

  **Optional Params**: `market`

      Spotify.Album.get_albums(conn, ids: "1,4")
      # => { :ok, %Spotify.Album{...} }
  """
  def get_albums(conn, params) do
    url = get_albums_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information for multiple albums identified by their Spotify IDs.

      iex> Spotify.Album.get_albums_url(ids: "1,3")
      "https://api.spotify.com/v1/albums?ids=1%2C3"
  """
  def get_albums_url(params) do
    "https://api.spotify.com/v1/albums" <> query_string(params)
  end

  @doc """
  Get Spotify catalog information about an album’s tracks.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-albums-tracks/)

  **Method**: `GET`
  **Optional Params**: `limit`, `offset`, `market`

      Spotify.Album.get_album_tracks("1")
      # => { :ok, %Paging{items: [%Spotify.Tracks{}, ...] } }
  """
  def get_album_tracks(conn, id, params \\ []) do
    url = get_album_tracks_url(id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information about an album’s tracks.

      iex> Spotify.Album.get_album_tracks_url("4")
      "https://api.spotify.com/v1/albums/4/tracks"
  """
  def get_album_tracks_url(id, params \\ []) do
    "https://api.spotify.com/v1/albums/#{id}/tracks" <> query_string(params)
  end

  @doc """
  Get Spotify catalog information about an artist’s albums. Optional parameters can be specified in the query string to filter and sort the response.

  [Spotify Documentation](https://developer.spotify.com/web-api/get-artists-albums/)

  **Method**: `GET`

      Spotify.Album.get_arists_albums(conn, "4")
      # => { :ok, %Paging{items: [%Album{}, ..]} }
  """
  def get_artists_albums(conn, id) do
    url = get_artists_albums_url(id)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information about an artist’s albums. Optional parameters can be specified in the query string to filter and sort the response.

      iex> Spotify.Album.get_artists_albums_url("4")
      "https://api.spotify.com/v1/artists/4/albums"
  """
  def get_artists_albums_url(id) do
    "https://api.spotify.com/v1/artists/#{id}/albums"
  end

  @doc """
  Get a list of new album releases featured in Spotify
  [Spotify Documentation](https://developer.spotify.com/web-api/get-list-new-releases/)

  **Method**: `GET`
  **Optional Params**: `country`, `limit`, `offset`

      Spotify.Album.new_releases(conn, country: "US")
      # => { :ok, %Paging{items: [%Album{}, ..]} }
  """
  def new_releases(conn, params \\ []) do
    url = new_releases_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get a list of new album releases featured in Spotify

      iex> Spotify.Album.new_releases_url(country: "US")
      "https://api.spotify.com/v1/browse/new-releases?country=US"
  """
  def new_releases_url(params) do
    "https://api.spotify.com/v1/browse/new-releases" <> query_string(params)
  end

  @doc """
  Save one or more albums to the current user’s “Your Music” library.
  [Spotify Documentation](https://developer.spotify.com/web-api/save-albums-user/)

  **Method**: `PUT`
  **Required Params**: `ids`

      Spotify.Album.save_albums(conn, ids: "1,4")
      # => :ok
  """

  def save_albums(conn, params) do
    url = save_albums_url(params)
    conn |> Client.put(url) |> handle_response
  end

  @doc """
  Save one or more albums to the current user’s “Your Music” library.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-saved-albums/)

      iex> Spotify.Album.save_albums_url(ids: "1,4")
      "https://api.spotify.com/v1/me/albums?ids=1%2C4"
  """
  def save_albums_url(params) do
    "https://api.spotify.com/v1/me/albums" <> query_string(params)
  end

  @doc """
  Get a list of the albums saved in the current Spotify user’s “Your Music” library.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-saved-albums/)

  **Method**: `GET`
  **Optional Params**: `limit`, `offset`, `market`

      Spotify.Album.my_albums(conn, limit: 5)
      # => { :ok, %Paging{items: [%Album{}, ...]} }
  """
  def my_albums(conn, params) do
    url = my_albums_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get a list of the albums saved in the current Spotify user’s “Your Music” library.

      iex> Spotify.Album.my_albums_url(limit: 5)
      "https://api.spotify.com/v1/me/albums?limit=5"
  """
  def my_albums_url(params) do
    "https://api.spotify.com/v1/me/albums" <> query_string(params)
  end

  @doc """
  Remove one or more albums from the current user’s “Your Music” library.
  [Spotify Documentation](https://developer.spotify.com/web-api/remove-albums-user/)

  **Method**: `DELETE`

      Spotify.Album.remove_albums(conn, ids: "1,4")
      # => :ok
  """
  def remove_albums(conn, params) do
    url = remove_albums_url(params)
    conn |> Client.delete(url) |> handle_response
  end

  @doc """
  Remove one or more albums from the current user’s “Your Music” library.

    iex> Spotify.Album.remove_albums_url(ids: "1,4")
    "https://api.spotify.com/v1/me/albums?ids=1%2C4"
  """
  def remove_albums_url(params) do
    "https://api.spotify.com/v1/me/albums" <> query_string(params)
  end

  @doc """
  Check if one or more albums is already saved in the current Spotify user’s “Your Music” library.
  [Spotify Documentation](https://developer.spotify.com/web-api/check-users-saved-albums/)

  **Method**: `GET`

      Spotify.Album.check_albums(ids: "1,4")
      # => [true, false]  (Album 1 is in the user's library, 4 is not)
  """
  def check_albums(conn, params) do
    url = check_albums_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Check if one or more albums is already saved in the current Spotify user’s “Your Music” library.

      iex> Spotify.Album.check_albums_url(ids: "1,4")
      "https://api.spotify.com/v1/me/albums/contains?ids=1%2C4"
  """
  def check_albums_url(params) do
    "https://api.spotify.com/v1/me/albums/contains" <> query_string(params)
  end

  @doc """
  Implement the callback required by the `Responder` behavior
  """
  def build_response(body) do
    case body do
      %{"albums" => albums} -> build_albums(albums)
      %{"items" => items} -> infer_type_and_build(items)
      %{"album_type" => _} -> build_album(body)
    end
  end

  @doc false
  def infer_type_and_build(items) do
    case List.first(items) do
      %{"track_number" => _} -> build_tracks(items)
      %{"album_type" => _} -> build_albums(items)
      %{"album" => _} -> build_albums(items)
    end
  end

  @doc false
  def build_tracks(tracks) do
    paging = %Paging{items: tracks}
    tracks = Track.build_tracks(tracks)
    Map.put(paging, :items, tracks)
  end

  @doc false
  def build_album(album) do
    album = to_struct(Album, album)
    paging = to_struct(Paging, album.tracks)
    tracks = Enum.map(paging.items, &to_struct(Track, &1))
    paging = Map.put(paging, :items, tracks)
    Map.put(album, :tracks, paging)
  end

  @doc false
  def build_albums(albums), do: Enum.map(albums, &build_album/1)
end
