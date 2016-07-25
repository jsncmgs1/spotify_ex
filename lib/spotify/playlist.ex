defmodule Spotify.Playlist do

  @moduledoc """
    Endpoints for retrieving information about a user’s playlists and for
    managing a user’s playlists.

    Each endpoint has normal function which returns the endpoint URL, and a
    bang version which makes the request and returns a `HTTPoison.Response` struct.

        Spotify.Playlist.featured!(country: "US")
        # => %HTTPoison.Response{...}

        Spotify.Playlist.featured
        # => "https://api.spotify.com/v1/browse/featured-playlists"

    API calls in this module require valid Authorization headers. See the OAuth
    section for more details.

    https://developer.spotify.com/web-api/playlist-endpoints/
  """

  import Helpers, only: [query_string: 1, to_struct: 2]
  alias Spotify.Client

  defstruct ~w[ collaborative description external_urls followers
    href id images name owner public snapshot_id tracks type uri ]a

  @doc"""
  Get a list of featured playlists.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-list-featured-playlists/)

  **Valid params**: `locale`, `country`, `timestamp`, `limit`, `offset`

  **Method**: `GET`

      Spotify.Playlist.featured(country: "US")
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.featured_url(country: "US")
      "https://api.spotify.com/v1/browse/featured-playlists?country=US"
  """
  defmacro send_request(request) do
    quote do
      case unquote(request) do
        { :ok, %HTTPoison.Response{ status_code: 200, body: body } } ->
          body = Poison.decode!(body)

          IO.inspect "***************** SPOTIFY RESPONSE BODY **************"
          IO.inspect body

          data = case body["playlists"] do
            nil -> to_struct(__MODULE__, body)
            playlists ->
              Enum.into(playlists["items"], [], fn(playlist) ->
                to_struct(__MODULE__, playlist)
              end)
          end
          { :ok, data }
        rest -> rest
      end
    end
  end

  def featured(conn, params \\ []) do
    send_request Client.get(conn, featured_url(params))
  end

  def featured_url(params \\ [])  do
    "https://api.spotify.com/v1/browse/featured-playlists" <> query_string(params)
  end


  @doc"""
  Get a category's playlists.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-categorys-playlists/)

  **Valid params**: `country`, `limit`, `offset`

  **Method**: `GET`

  ## Example:
      Spotify.by_category!
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.by_category("123")
      "https://api.spotify.com/v1/browse/categories/123/playlists"

      iex> Spotify.Playlist.by_category("123", [country: "US", limit: 5])
      "https://api.spotify.com/v1/browse/categories/123/playlists?country=US&limit=5"
  """
  def by_category(id, params \\ []) do
    "https://api.spotify.com/v1/browse/categories/#{id}/playlists" <> query_string(params)
  end

  def by_category!(id, params \\ []) do
    Client.get(by_category(params))
  end

  @doc """
  Add the current user as a follower of a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/follow-playlist/)

  **Optional Body Params**: `public`

  **Method**: `PUT`
      Spotify.Playlist.follow_playlist!("123", "456")
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.follow_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/followers"
  """
  def follow_playlist(owner_id, playlist_id) do
    follow_playlist_url(owner_id, playlist_id)
  end

  def follow_playlist!(owner_id, playlist_id, body \\ "") do
    url = follow_playlist_url(owner_id, playlist_id)
    Client.put(url, body)
  end

  @doc """
  Remove the current user as a follower of a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/unfollow-playlist/)

  **Method**: `DELETE`

      Spotify.Playlist.unfollow_playlist("123", "456")
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.unfollow_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/followers"
  """
  def unfollow_playlist(owner_id, playlist_id) do
    follow_playlist_url(owner_id, playlist_id)
  end

  def unfollow_playlist!(owner_id, playlist_id) do
    url = unfollow_playlist(owner_id, playlist_id)
    Client.delete(url)
  end

  @doc false
  defp follow_playlist_url(owner_id, playlist_id) do
    get_playlist_url(owner_id, playlist_id) <>"/followers"
  end

  @doc """
  Search for a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/search-item/)

  **Method**: `GET`

  **Required Params:** `q`

  **Optional Params:** `limit`, `offset`, `market`

      Spotify.Playlist.search!(q: "foo", limit: 5)
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.search(q: "foo", limit: 5)
      "https://api.spotify.com/v1/search?type=playlist&q=foo&limit=5"

  """

  def search(params)  do
    "https://api.spotify.com/v1/search?type=playlist&" <> URI.encode_query(params)
  end

  def search!(params) do
    Client.get(search(params))
  end

  @doc """
  Get a list of the playlists owned or followed by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-list-users-playlists/)

  **Method**: `GET`

  ** Optional Params: `limit`, `offset`

      Spotify.Playlist.get_users_playlists!("123", q: "foo", limit: 5)
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.get_users_playlists("123")
      "https://api.spotify.com/v1/users/123/playlists"

      iex> Spotify.Playlist.get_users_playlists("123", limit: 5)
      "https://api.spotify.com/v1/users/123/playlists?limit=5"
  """

  def get_users_playlists(user_id, params \\ []) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists" <> query_string(params)
  end

  def get_users_playlists!(user_id, params \\ []) do
    Client.get(get_users_playlists(user_id, params))
  end

  @doc """
  Get a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlist/)

  **Method**: `GET`

  **Optional Params `fields, market`

      Spotify.Playlist.get_playlist!("123", "456")
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.get_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456"

      iex> Spotify.Playlist.get_playlist("123", "456", market: "foo")
      "https://api.spotify.com/v1/users/123/playlists/456?market=foo"
  """

  def get_playlist(user_id, playlist_id, params \\ []) do
    get_playlist_url(user_id, playlist_id) <> query_string(params)
  end

  def get_playlist!(user_id, playlist_id, params \\ []) do
    url = get_playlist(user_id, playlist_id, params)
    Client.get(url)
  end

  defp get_playlist_url(user_id, playlist_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}"
  end

  @doc """
  Get full details of the tracks of a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlists-tracks/)

  **Method**: `GET`

  **Optional Params `fields`, `market`, `limit`, `offset`
      Spotify.Playlist.get_playlist_tracks!("123", "456")
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.get_playlist_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"

      iex> Spotify.Playlist.get_playlist_tracks("123", "456", limit: 5, offset: 5)
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?limit=5&offset=5"
  """
  def get_playlist_tracks(user_id, playlist_id, params \\ []) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  def get_playlist_tracks!(user_id, playlist_id, params \\ []) do
    url = get_playlist_tracks(user_id, playlist_id, params)
    Client.get(url)
  end

  defp playlist_tracks_url(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id) <> "/tracks"
  end

  @doc """
  Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)
  [Spotify Documentation](https://developer.spotify.com/web-api/create-playlist/)

  **Method**: `POST`

  **Body Params**: `name`, `public`

      body = "\{\"name\": \"foo\"}"
      Spotify.Playlist.create_playlist("123", body)
      # => %HTTPoison.Response{..}

      iex> Spotify.Playlist.create_playlist("123")
      "https://api.spotify.com/v1/users/123/playlists"
  """
  def create_playlist(user_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists"
  end

  def create_playlist!(user_id, body) do
    url = create_playlist(user_id)
    Client.post(url, body)
  end

  @doc """
  Change a playlist’s name and public/private state. (The user must, of course, own the playlist.)
  [Spotify Documentation](https://developer.spotify.com/web-api/change-playlist-details/)

  **Method**: `PUT`

  **Request Data)**: `name`, `public`

      body = { "name": "foo", "public": true }
      Spotify.Playlist.change_playlist!("123", "456", body)
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.change_playlist("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456"

  """
  def change_playlist(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id)
  end

  def change_playlist!(user_id, playlist_id, body) do
    url = change_playlist(user_id, playlist_id)
    Client.put(url, body)
  end

  @doc """
  Add one or more tracks to a user’s playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/add-tracks-to-playlist/)

  **Method**: `POST`

  **Optional Params**: `uris`, `position`

  You can also pass the URI param in the request body. Use `add_tracks/2`. See Spotify docs.
      Spotify.Playlist.add_tracks!("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
      # => %HTTPoison.Response{..}

      iex> Spotify.Playlist.add_tracks("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh"

      iex> Spotify.Playlist.add_tracks("123", "456") # Must send request data using this function
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"

  """
  def add_tracks(user_id, playlist_id, params \\ []) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  def add_tracks!(user_id, playlist_id, params \\ []) do
    url = add_tracks(user_id, playlist_id, params)
    Client.post(url)
  end

  @doc """
  Remove one or more tracks from a user’s playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/remove-tracks-playlist/)

  **Method**: `DELETE`

  **Request Data**: `tracks`

      Spotify.Playlist.remove_tracks!("123", "456")
      # => %HTTPoison.Response{..}

      iex> Spotify.Playlist.remove_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"
  """
  def remove_tracks(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  def remove_tracks!(user_id, playlist_id) do
    url = playlist_tracks_url(user_id, playlist_id)
    Client.delete(url)
  end

  @doc """
  Reorder a track or a group of tracks in a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/reorder-playlists-tracks/)

  **Method**: `PUT`

  **Required Request Body Data**: `range_start`, `insert_before`

  **Optional Request Body Data**: `range_length`, `snapshot_id`

      body = { "range_start": "..." }
      Spotify.Playlist.change_playlist!("123", "456", body)
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.reorder_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"

  """
  def reorder_tracks(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  def reorder_tracks!(user_id, playlist_id, body) do
    url = playlist_tracks_url(user_id, playlist_id)
    Client.put(url, body)
  end

  @doc """
  Replace all the tracks in a playlist, overwriting its existing tracks. This
  powerful request can be useful for replacing tracks, re-ordering existing
  tracks, or clearing the playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/replace-playlists-tracks/)

  **Method**: `PUT`

  **Optional Query Params**: `uris`

  You can also pass the URI param in the request body. Use `replace_tracks/2`. See Spotify docs.
      Spotify.Playlist.replace_tracks!("123", "456")
      # => %HTTPoison.Response{...}

      iex> Spotify.Playlist.replace_tracks("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks" # Must send request data

      iex> Spotify.Playlist.replace_tracks("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh,spotify:track:adkjaklsd94h")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh%2Cspotify%3Atrack%3Aadkjaklsd94h"
  """
  def replace_tracks(user_id, playlist_id, params \\ []) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  def replace_tracks!(user_id, playlist_id, params \\ []) do
    url = replace_tracks(user_id, playlist_id, params)
    Client.put(url)
  end

  @doc """
  Check to see if one or more Spotify users are following a specified playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/check-user-following-playlist/)

  **Method**: `GET`

  **Query Params: `ids`

      Spotify.Playlist.check_followers!("123", "456", ids: "foo,bar")
      # => %HTTPoison.Response{..}

      iex> Spotify.Playlist.check_followers("123", "456", ids: "foo,bar")
      "https://api.spotify.com/v1/users/123/playlists/456/followers/contains?ids=foo%2Cbar"
  """
  def check_followers(owner_id, playlist_id, params) do
    "https://api.spotify.com/v1/users/#{owner_id}/playlists/#{playlist_id}/followers/contains"
    <> query_string(params)
  end

  def check_followers!(owner_id, playlist_id, params) do
    url = check_followers(owner_id, playlist_id, params)
    Client.get(url)
  end

end
