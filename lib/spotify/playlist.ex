defmodule Spotify.Playlist do
  import Helpers, only: [query_string: 1]

  @moduledoc """
    Playlist API endpoints

    API calls in this module require valid Authorization headers. See the OAuth
    section for more details.

    https://developer.spotify.com/web-api/playlist-endpoints/
  """

  @featured_url "https://api.spotify.com/v1/browse/featured-playlists"

  @doc"""
  Get a list of featured playlists.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-list-featured-playlists/)

  **Method**: `GET`

      iex> Spotify.Playlist.featured
      "https://api.spotify.com/v1/browse/featured-playlists"
  """
  def featured, do: @featured_url

  @doc"""
  Get a list of featured playlists.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-list-featured-playlists/)

  **Valid params**: `locale`, `country`, `timestamp`, `limit`, `offset`

  **Method**: `GET`

      iex> Spotify.Playlist.featured(country: "US")
      "https://api.spotify.com/v1/browse/featured-playlists?country=US"
  """
  def featured(params) when is_list(params) or is_map(params) do
    @featured_url <> query_string(params)
  end

  @doc"""
  Get a category's playlists.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-categorys-playlists/)

      iex> Spotify.Playlist.by_category("123")
      "https://api.spotify.com/v1/browse/categories/123/playlists"
  """
  def by_category(id), do: category_url(id)

  @doc"""
  Get a category's playlists with additional parameters.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-categorys-playlists/)

  **Valid params**: `country`, `limit`, `offset`

  **Method**: `GET`

  ## Example:
      iex> Spotify.Playlist.by_category("123", [country: "US", limit: 5])
      "https://api.spotify.com/v1/browse/categories/123/playlists?country=US&limit=5"
  """
  def by_category(id, params) when is_list(params) or is_map(params) do
    by_category(id) <> query_string(params)
  end

  @doc false
  def category_url(id) do
    "https://api.spotify.com/v1/browse/categories/#{id}/playlists"
  end

  @doc """
  Add the current user as a follower of a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/follow-playlist/)

  **Optional Body Params**: `public`

  **Method**: `PUT`

      iex> Spotify.Playlist.follow_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/followers"
  """
  def follow_playlist(owner_id, playlist_id) do
    follow_playlist_url(owner_id, playlist_id)
  end

  @doc """
  Remove the current user as a follower of a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/unfollow-playlist/)

  **Method**: `DELETE`

      iex> Spotify.Playlist.follow_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/followers"
  """
  def unfollow_playlist(owner_id, playlist_id) do
    follow_playlist_url(owner_id, playlist_id)
  end

  @doc false
  defp follow_playlist_url(owner_id, playlist_id) do
    get_playlist_url(owner_id, playlist_id) <>"/followers"
  end

  @doc """
  Search for a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/search-item/)

  **Method**: `GET`

  ** Required Params: `q`

  ** Optional Params: `limit`, `offset`, `market`

      iex> Spotify.Playlist.search(q: "foo", limit: 5)
      "https://api.spotify.com/v1/search?type=playlist&q=foo&limit=5"

  """

  def search(params)  do
    "https://api.spotify.com/v1/search?type=playlist&" <> URI.encode_query(params)
  end

  @doc """
  Get a list of the playlists owned or followed by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-list-users-playlists/)

  **Method**: `GET`

      iex> Spotify.Playlist.get_users_playlists("123")
      "https://api.spotify.com/v1/users/123/playlists"
  """
  def get_users_playlists(user_id) do
    get_users_playlist_url(user_id)
  end

  @doc """
  Get a list of the playlists owned or followed by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-list-users-playlists/)

  **Method**: `GET`
  ** Optional Params: `limit`, `offset`

      iex> Spotify.Playlist.get_users_playlists("123", limit: 5)
      "https://api.spotify.com/v1/users/123/playlists?limit=5"
  """

  def get_users_playlists(user_id, params) do
    get_users_playlist_url(user_id) <> query_string(params)
  end

  defp get_users_playlist_url(user_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists"
  end

  @doc """
  Get a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlist/)

  **Method**: `GET`

      iex> Spotify.Playlist.get_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456"

  """
  def get_playlist(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id)
  end

  @doc """
  Get a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlist/)

  **Method**: `GET`
  **Optional Params `fields, market`

      iex> Spotify.Playlist.get_playlist("123", "456", market: "foo")
      "https://api.spotify.com/v1/users/123/playlists/456?market=foo"
  """
  def get_playlist(user_id, playlist_id, params) do
    get_playlist_url(user_id, playlist_id) <> query_string(params)
  end

  defp get_playlist_url(user_id, playlist_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}"
  end

  @doc """
  Get full details of the tracks of a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlists-tracks/)

  **Method**: `GET`

      iex> Spotify.Playlist.get_playlist_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"
  """
  def get_playlist_tracks(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  @doc """
  Get full details of the tracks of a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlists-tracks/)

  **Method**: `GET`
  **Optional Params `fields`, `market`, `limit`, `offset`

      iex> Spotify.Playlist.get_playlist_tracks("123", "456", limit: 5, offset: 5)
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?limit=5&offset=5"
  """
  def get_playlist_tracks(user_id, playlist_id, params) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  defp playlist_tracks_url(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id) <> "/tracks"
  end

  @doc """
  Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)
  [Spotify Documentation](https://developer.spotify.com/web-api/create-playlist/)

  **Method**: `POST`
  **Body Params**: `name`, `public`

      iex> Spotify.Playlist.create_playlist("123")
      "https://api.spotify.com/v1/users/123/playlists"
  """
  def create_playlist(user_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists"
  end

  @doc """
  Change a playlist’s name and public/private state. (The user must, of course, own the playlist.)
  [Spotify Documentation](https://developer.spotify.com/web-api/change-playlist-details/)

  **Method**: `PUT`
  **Request Data)**: `name`, `public`

      iex> Spotify.Playlist.change_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456"

  """
  def change_playlist(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id)
  end

  @doc """
  Add one or more tracks to a user’s playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/add-tracks-to-playlist/)

  **Method**: `POST`
  **Optional Params**: `uris`, `position`

  You can also pass the URI param in the request body. Use `add_tracks/2`. See Spotify docs.

      iex> Spotify.Playlist.add_tracks("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh"
  """

  def add_tracks(user_id, playlist_id, params) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  def add_tracks(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  @doc """
  Remove one or more tracks from a user’s playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/remove-tracks-playlist/)
  **Method**: `DELETE`
  **Request Data**: `tracks`

      iex> Spotify.Playlist.remove_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"
  """
  def remove_tracks(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  @doc """
  Reorder a track or a group of tracks in a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/reorder-playlists-tracks/)

  **Method**: `PUT`
  **Required Request Body Data**: `range_start`, `insert_before`
  **Optional Request Body Data**: `range_length`, `snapshot_id`

      iex> Spotify.Playlist.reorder_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"

  """
  def reorder_tracks(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

end
