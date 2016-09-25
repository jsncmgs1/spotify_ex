defmodule Spotify.Playlist do

  @moduledoc """
    Functions for retrieving information about a user’s playlists and for
    managing a user’s playlists.

    Some endpoints return collections. Spotify wraps the collection in a paging object,
    this API does the same. A single piece of data will not be wrapped.

    There are two functions for each endpoint, one that actually makes the request,
    and one that provides the endpoint:

        Spotify.Playist.create_playlist(conn, "foo", "bar") # makes the POST request.
        Spotify.Playist.create_playlist_url("foo", "bar") # provides the url for the request.


    https://developer.spotify.com/web-api/playlist-endpoints/
  """

  import Helpers
  use Responder
  alias Spotify.Client

  defstruct ~w[ collaborative description external_urls followers
    href id images name owner public snapshot_id tracks type uri ]a

  @doc"""
  Get a list of featured playlists.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-list-featured-playlists/)

  **Valid params**: `locale`, `country`, `timestamp`, `limit`, `offset`

  **Method**: `GET`

      Spotify.Playlist.featured(country: "US")
      # => {:ok, %{ items: [%Spotify.Playlist{..} ...]}}
  """
  def featured(conn, params \\ []) do
    url = featured_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc"""
  Get a list of featured playlists.

      iex> Spotify.Playlist.featured_url(country: "US")
      "https://api.spotify.com/v1/browse/featured-playlists?country=US"
  """
  def featured_url(params \\ [])  do
    "https://api.spotify.com/v1/browse/featured-playlists" <> query_string(params)
  end

  @doc"""
  Get a category's playlists.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-categorys-playlists/)

  **Valid params**: `country`, `limit`, `offset`

  **Method**: `GET`

  ## Example:
      Spotify.by_category(conn, "123")
      # => {:ok, %{ items: [%Spotify.Playlist{..} ...]}}
  """
  def by_category(conn, id, params \\ []) do
    url = by_category_url(id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc"""
  Get a category's playlists.

      iex> Spotify.Playlist.by_category_url("123", [country: "US", limit: 5])
      "https://api.spotify.com/v1/browse/categories/123/playlists?country=US&limit=5"
  """
  def by_category_url(id, params \\ []) do
    "https://api.spotify.com/v1/browse/categories/#{id}/playlists" <> query_string(params)
  end

  @doc """
  Add the current user as a follower of a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/follow-playlist/)

  **Optional Body Params**: `public`

  **Method**: `PUT`
      Spotify.Playlist.follow_playlist(conn, "123", "456")
      # => :ok
  """
  def follow_playlist(conn, owner_id, playlist_id, body \\ "") do
    url = follow_playlist_url(owner_id, playlist_id)
    conn |> Client.put(url, body) |> handle_response

  end

  @doc"""
  Add the current user as a follower of a playlist.

      iex> Spotify.Playlist.follow_playlist_url("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/followers"
  """
  def follow_playlist_url(owner_id, playlist_id) do
    get_playlist_url(owner_id, playlist_id) <>"/followers"
  end

  @doc """
  Remove the current user as a follower of a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/unfollow-playlist/)

  **Method**: `DELETE`

      Spotify.Playlist.unfollow_playlist(conn, "123", "456")
      # => :ok
  """
  def unfollow_playlist(conn, owner_id, playlist_id) do
    url = unfollow_playlist_url(owner_id, playlist_id)
    conn |> Client.delete(url) |> handle_response
  end

  @doc"""
  Remove the current user as a follower of a playlist.

      iex> Spotify.Playlist.unfollow_playlist_url("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/followers"
  """
  def unfollow_playlist_url(owner_id, playlist_id) do
    follow_playlist_url(owner_id, playlist_id)
  end

  @doc """
  Get a list of the playlists owned or followed by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-list-users-playlists/)

  **Method**: `GET`

  ** Optional Params: `limit`, `offset`

      Spotify.Playlist.get_users_playlists(conn, "123", q: "foo", limit: 5)
      # => {:ok, %{ items: [%Spotify.Playlist{..} ...]}}
  """
  def get_users_playlists(conn, user_id, params \\ []) do
    url = get_users_playlists_url(user_id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc"""
  Get a list of the playlists owned or followed by a Spotify user.

      iex> Spotify.Playlist.get_users_playlists_url("123", limit: 5)
      "https://api.spotify.com/v1/users/123/playlists?limit=5"
  """
  def get_users_playlists_url(user_id, params \\ []) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists" <> query_string(params)
  end


  @doc """
  Get a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlist/)

  **Method**: `GET`

  **Optional Params `fields, market`

      Spotify.Playlist.get_playlist(conn, "123", "456")
      # => {:ok, %Spotify.Playlist{..}}
  """
  def get_playlist(conn, user_id, playlist_id, params \\ []) do
    url = get_playlist_url(user_id, playlist_id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc"""
  Get a playlist owned by a Spotify user.

      iex> Spotify.Playlist.get_playlist_url("123", "456", market: "foo")
      "https://api.spotify.com/v1/users/123/playlists/456?market=foo"
  """
  def get_playlist_url(user_id, playlist_id, params \\ []) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists/#{playlist_id}" <> query_string(params)
  end

  @doc """
  Get full details of the tracks of a playlist owned by a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-playlists-tracks/)

  **Method**: `GET`

  **Optional Params `fields`, `market`, `limit`, `offset`
      Spotify.Playlist.get_playlist_tracks(conn, "123", "456")
      # => {:ok, %Spotify.Playlist{..}}
  """
  def get_playlist_tracks(conn, user_id, playlist_id, params \\ []) do
    alias Spotify.Playlist.Track, as: Track

    url = get_playlist_tracks(user_id, playlist_id, params)
    conn |> Client.get(url) |> Track.handle_response
  end

  @doc"""
  Get full details of the tracks of a playlist owned by a Spotify user.

      iex> Spotify.Playlist.get_playlist_tracks_url("123", "456", limit: 5, offset: 5)
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?limit=5&offset=5"
  """
  def get_playlist_tracks_url(user_id, playlist_id, params \\ []) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  def playlist_tracks_url(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id) <> "/tracks"
  end

  @doc """
  Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)
  [Spotify Documentation](https://developer.spotify.com/web-api/create-playlist/)

  **Method**: `POST`

  **Body Params**: `name`, `public`

      body = "\{\"name\": \"foo\"}"
      Spotify.Playlist.create_playlist(conn, "123", body)
      # => %Spotify.Playlist{..}
  """
  def create_playlist(conn, user_id, body) do
    url = create_playlist_url(user_id)
    conn |> Client.post(url, body) |> handle_response
  end
  @doc"""
  Create a playlist for a Spotify user. (The playlist will be empty until you add tracks.)

      iex> Spotify.Playlist.create_playlist_url("123")
      "https://api.spotify.com/v1/users/123/playlists"
  """
  def create_playlist_url(user_id) do
    "https://api.spotify.com/v1/users/#{user_id}/playlists"
  end


  @doc """
  Change a playlist’s name and public/private state. (The user must, of course, own the playlist.)
  [Spotify Documentation](https://developer.spotify.com/web-api/change-playlist-details/)

  **Method**: `PUT`

  **Request Data)**: `name`, `public`

      body = "{ \"name\": \"foo\", \"public\": true }"
      Spotify.Playlist.change_playlist(conn, "123", "456", body)
      # => :ok
  """
  def change_playlist(conn, user_id, playlist_id, body) do
    url = change_playlist_url(user_id, playlist_id)
    conn |> Client.put(url, body) |> handle_response
  end

  @doc"""
  Change a playlist’s name and public/private state. (The user must, of course, own the playlist.)

      iex> Spotify.Playlist.change_playlist_url("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456"
  """
  def change_playlist_url(user_id, playlist_id) do
    get_playlist_url(user_id, playlist_id)
  end


  @doc """
  Add one or more tracks to a user’s playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/add-tracks-to-playlist/)

  **Method**: `POST`

  **Optional Params**: `uris`, `position`

  You can also pass the URI param in the request body. Use `add_tracks/2`. See Spotify docs.
      Spotify.Playlist.add_tracks("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
      # => {:ok, %{"snapshot_id" => "foo"}}
  """
  def add_tracks(conn, user_id, playlist_id, params \\ []) do
    url = add_tracks_url(user_id, playlist_id, params)
    conn |> Client.put(url) |> handle_response
  end

  @doc"""
  Add one or more tracks to a user’s playlist.

      iex> Spotify.Playlist.add_tracks_url("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh"
  """
  def add_tracks_url(user_id, playlist_id, params \\ []) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end


  @doc """
  Remove one or more tracks from a user’s playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/remove-tracks-playlist/)

  **Method**: `DELETE`

  **Request Data**: `tracks`

      Spotify.Playlist.remove_tracks(conn, "123", "456")
      # => {:ok, %{"snapshot_id": "foo"}}
  """
  def remove_tracks(conn, user_id, playlist_id) do
    url = playlist_tracks_url(user_id, playlist_id)
    conn |> Client.delete(url) |> handle_response
  end

  @doc"""
  Remove one or more tracks from a user’s playlist.

      iex> Spotify.Playlist.remove_tracks_url("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"
  """
  def remove_tracks_url(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  @doc """
  Reorder a track or a group of tracks in a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/reorder-playlists-tracks/)

  **Method**: `PUT`

  **Required Request Body Data**: `range_start`, `insert_before`

  **Optional Request Body Data**: `range_length`, `snapshot_id`

      body = { \"range_start\": \"...\" }
      Spotify.Playlist.change_playlist(conn, "123", "456", body)
      # => {:ok, %{"snapshot_id" => "klq34klj..."} }
  """
  def reorder_tracks(conn, user_id, playlist_id, body) do
    url = playlist_tracks_url(user_id, playlist_id)
    conn |> Client.put(url, body) |> handle_response
  end

  @doc"""
  Reorder a track or a group of tracks in a playlist.

      iex> Spotify.Playlist.reorder_tracks_url("123", "456")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks"
  """
  def reorder_tracks_url(user_id, playlist_id) do
    playlist_tracks_url(user_id, playlist_id)
  end

  @doc """
  Replace all the tracks in a playlist, overwriting its existing tracks. This
  powerful request can be useful for replacing tracks, re-ordering existing
  tracks, or clearing the playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/replace-playlists-tracks/)

  **Method**: `PUT`

  **Optional Query Params**: `uris`

  You can also pass the URI param in the request body. Use `replace_tracks/2`. See Spotify docs.
      Spotify.Playlist.replace_tracks(conn, "123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh,spotify:track:adkjaklsd94h")
      :ok
  """
  def replace_tracks(conn, user_id, playlist_id, params \\ []) do
    url = replace_tracks_url(user_id, playlist_id, params)
    conn |> Client.put(url) |> handle_response
  end

  @doc"""
  Replace all the tracks in a playlist, overwriting its existing tracks. This

      iex> Spotify.Playlist.replace_tracks_url("123", "456", uris: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh,spotify:track:adkjaklsd94h")
      "https://api.spotify.com/v1/users/123/playlists/456/tracks?uris=spotify%3Atrack%3A4iV5W9uYEdYUVa79Axb7Rh%2Cspotify%3Atrack%3Aadkjaklsd94h"
  """
  def replace_tracks_url(user_id, playlist_id, params \\ []) do
    playlist_tracks_url(user_id, playlist_id) <> query_string(params)
  end

  @doc """
  Check to see if one or more Spotify users are following a specified playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/check-user-following-playlist/)

  **Method**: `GET`

  **Query Params: `ids`

      Spotify.Playlist.check_followers(conn, "123", "456", ids: "foo,bar")
      # => {:ok, boolean}
  """
  def check_followers(conn, owner_id, playlist_id, params) do
    url = check_followers_url(owner_id, playlist_id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc"""
  Check to see if one or more Spotify users are following a specified playlist.

      iex> Spotify.Playlist.check_followers_url("123", "456", ids: "foo,bar")
      "https://api.spotify.com/v1/users/123/playlists/456/followers/contains?ids=foo%2Cbar"
  """
  def check_followers_url(owner_id, playlist_id, params) do
    "https://api.spotify.com/v1/users/#{owner_id}/playlists/#{playlist_id}/followers/contains"
    <> query_string(params)
  end

  @doc """
  Implements the hook expected by the Responder behaviour
  """
  def build_response(body) do
    case body do
      %{"playlists" => playlists} -> %Paging{items: build_playlists(playlists["items"])}
      _ -> to_struct(__MODULE__, body)
    end
  end

  @doc false
  def build_playlists(playlists) do
    Enum.map(playlists, &to_struct(__MODULE__, &1))
  end

end
