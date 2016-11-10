defmodule Spotify.Search do
  @moduledoc """
  Spotify search endpoints. Spotify allows querying for artists, albums, playlists, and tracks.
  """

  use Responder
  import Helpers
  alias Spotify.{Client, Album, Artist, Playlist, Track}

  @keys ["albums", "artists", "playlists", "tracks"]

  @doc """
  Search for a playlist.
  [Spotify Documentation](https://developer.spotify.com/web-api/search-item/)

  **Method**: `GET`

  **Required Params:** `q`, `type`

  **Optional Params:** `limit`, `offset`, `market`

      Spotify.Search.query(conn, q: "foo", type: "playlist")
      # => {:ok, %{ items: [%Spotify.Playlist{..} ...]}}
  """
  def query(conn, params)  do
    url = query_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc"""
  Search for a playlist, artist, album, or track.
      iex> Spotify.Search.query_url(q: "foo", type: "playlist")
      "https://api.spotify.com/v1/search?q=foo&type=playlist"
  """
  def query_url(params)  do
    "https://api.spotify.com/v1/search" <> query_string(params)
  end

  @doc """
  Implements the hook required by the `Responder` behaviour
  """
  def build_response(body) do
    {items, _rest} = body
                     |> Map.take(@keys)
                     |> Map.to_list
                     |> Enum.flat_map_reduce([], fn({key, data}, acc) ->
                       {map_to_struct(key, data["items"]), acc}
                     end)
    Paging.response(body, items)
  end

  def map_to_struct("artists", artists), do: Artist.build_artists(artists)
  def map_to_struct("tracks", tracks), do: Track.build_tracks(tracks)
  def map_to_struct("playlists", playlists), do: Playlist.build_playlists(playlists)
  def map_to_struct("albums", albums), do: Enum.map(albums, &to_struct(Album, &1))

  @doc false
  def build_albums(body, albums) do
    albums = Enum.map(albums, &to_struct(Album, &1))
    Paging.response(body, albums)
  end

  @doc false
  def build_artists(body, artists) do
    artists = Artist.build_artists(artists)
    Paging.response(body, artists)
  end

  @doc false
  def build_playlists(body, playlists) do
    playlists = Playlist.build_playlists(playlists)
    Paging.response(body, playlists)
  end

  @doc false
  def build_tracks(body, tracks) do
    tracks = Track.build_tracks(tracks)
    Paging.response(body, tracks)
  end
end
