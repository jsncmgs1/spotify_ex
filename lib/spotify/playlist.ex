defmodule Spotify.Playlist do
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
    "https://api.spotify.com/v1/browse/categories/#{to_string(id)}/playlists"
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
    "https://api.spotify.com/v1/users/#{owner_id}/playlists/#{playlist_id}/followers"
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
  ** Optional Params `fields, market`

      iex> Spotify.Playlist.get_playlist("123", "456", market: "foo")
      "https://api.spotify.com/v1/users/123/playlists/456?market=foo"
  """
  def get_playlist(user_id, playlist_id, params) do
    get_playlist_url(user_id, playlist_id) <> query_string(params)
  end

  defp get_playlist_url(user_id, playlist_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}"
  end

  defp query_string(params) do
    "?" <> URI.encode_query(params)
  end

end
