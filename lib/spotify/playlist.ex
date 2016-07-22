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

  **Valid params**: `locale`, `country`, `timestamp`, `limit`, `offset`

  ## Example:
      iex> Spotify.Playlist.featured([limit: 5, country: "US"])
      "https://api.spotify.com/v1/browse/featured-playlists?limit=5&country=US"

      iex> Spotify.Playlist.featured
      "https://api.spotify.com/v1/browse/featured-playlists"
  """
  def featured(enum)
  def featured, do: @featured_url
  def featured(params) when is_list(params) or is_map(params) do
    @featured_url <> query_string(params)
  end

  def by_category(string)

  @doc"""
  Get a category's playlists.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-categorys-playlists/)

  ## Example:
      iex> Spotify.Playlist.by_category(123)
      "https://api.spotify.com/v1/browse/categories/123/playlists"
  """
  def by_category(id), do: category_url(id)

  @doc"""
  Get a category's playlists with additional parameters.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-categorys-playlists/)

  **Valid params**: `country`, `limit`, `offset`

  ## Example:
      iex> Spotify.Playlist.by_category(123, [country: "US", limit: 5])
      "https://api.spotify.com/v1/browse/categories/123/playlists?country=US&limit=5"
  """
  def by_category(string, enum)
  def by_category(id, params) when is_list(params) or is_map(params) do
    by_category(id) <> query_string(params)
  end

  defp category_url(id) do
    "https://api.spotify.com/v1/browse/categories/#{to_string(id)}/playlists"
  end

  defp query_string(params) do
    "?" <> URI.encode_query(params)
  end

end
