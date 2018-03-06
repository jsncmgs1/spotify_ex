defmodule Spotify.Artist do
  @moduledoc """
    Functions for retrieving information about artists and for
    managing a user’s followed artists.

    There are two functions for each endpoint, one that actually makes the request,
    and one that provides the endpoint:

        Spotify.Playist.create_playlist(conn, "foo", "bar") # makes the POST request.
        Spotify.Playist.create_playlist_url("foo", "bar") # provides the url for the request.

    https://developer.spotify.com/web-api/artist-endpoints/
  """

  import Helpers
  use Responder
  alias Spotify.{Client, Artist, Track}

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

      Spotify.Artist.get_artist(conn, "4")
      # => { :ok, %Artist{}}
  """
  def get_artist(conn, id) do
    url = get_artist_url(id)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information for a single artist identified by their unique Spotify ID.

      iex> Spotify.Artist.get_artist_url("4")
      "https://api.spotify.com/v1/artists/4"
  """
  def get_artist_url(id) do
    "https://api.spotify.com/v1/artists/#{id}"
  end

  @doc """
  Get Spotify catalog information for several artists based on their Spotify IDs.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-several-artists/)

  **Method**: `GET`

  **Required Params**: `ids`

      Spotify.Artist.get_artists(conn, ids: "1,4")
      # => { :ok, [%Artist{}, ...] }
  """
  def get_artists(conn, params = [ids: _ids]) do
    url = get_artists_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information for several artists based on their Spotify IDs.

      iex> Spotify.Artist.get_artists_url(ids: "1,4")
      "https://api.spotify.com/v1/artists?ids=1%2C4"
  """
  def get_artists_url(params) do
    "https://api.spotify.com/v1/artists" <> query_string(params)
  end

  @doc """
  Get Spotify catalog information about an artist’s top tracks by country.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-artists-top-tracks/)

  **Method**: `GET`

  **Required Params**: `country`

      Spotify.get_top_tracks(conn, "4", country: "US")
      # => { :ok, [%Track{}, ...] }
  """
  def get_top_tracks(conn, id, params) do
    url = get_top_tracks_url(id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get Spotify catalog information about an artist’s top tracks by country.

      iex> Spotify.Artist.get_top_tracks_url("4", country: "US")
      "https://api.spotify.com/v1/artists/4/top-tracks?country=US"
  """
  def get_top_tracks_url(id, params) do
    "https://api.spotify.com/v1/artists/#{id}/top-tracks" <> query_string(params)
  end

  @doc """
  Get Spotify catalog information about artists similar to a given artist.
  [Spotify Documenation](https://developer.spotify.com/web-api/get-related-artists/)

  ** Method **: `GET`

      Spotify.Artist.get_related_artists(conn, "4")
      # => { :ok, [ %Artist{}, ... ] }
  """
  def get_related_artists(conn, id) do
    url = get_related_artists_url(id)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
    Get Spotify catalog information about artists similar to a given artist.

        iex> Spotify.Artist.get_related_artists_url("4")
        "https://api.spotify.com/v1/artists/4/related-artists"
  """
  def get_related_artists_url(id) do
    "https://api.spotify.com/v1/artists/#{id}/related-artists"
  end

  @doc """
  Get the current user’s followed artists.

  **Method**: `GET`

  **Optional Params**: `type`, `limit`, `after`

      Spotify.Artist.artists_I_follow_url(conn)
      # => { :ok, %Paging{items: [%Artist{}, ...]} }
  """
  def artists_I_follow(conn, params \\ []) do
    url = artists_I_follow_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get the current user’s followed artists.

      iex> Spotify.Artist.artists_I_follow_url(limit: 5)
      "https://api.spotify.com/v1/me/following?type=artist&limit=5"
  """
  def artists_I_follow_url(params) do
    "https://api.spotify.com/v1/me/following?type=artist&" <> URI.encode_query(params)
  end

  @doc """
  Implements the hook expected by the Responder behaviour
  """
  def build_response(body) do
    case body do
      %{"artists" => %{"items" => _items}} = response -> build_paged_artists(response)
      %{"artists" => artists} -> build_artists(artists)
      %{"tracks" => tracks} -> Track.build_tracks(tracks)
      %{"name" => _} -> to_struct(Artist, body)
      booleans_or_error -> booleans_or_error
    end
  end

  @doc false
  defp build_paged_artists(%{"artists" => response}) do
    %Paging{
      items: build_artists(response["items"]),
      next: response["next"],
      total: response["total"],
      cursors: response["cursors"],
      limit: response["limit"],
      href: response["href"]
    }
  end

  @doc false
  def build_artists(artists) do
    Enum.map(artists, &to_struct(Artist, &1))
  end
end
