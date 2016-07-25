defmodule Spotify.Profile do
  @moduledoc """
  Endpoints for retrieving information about a user’s profile.

  Each endpoint has normal function which returns the endpoint URL, and a
  bang version which makes the request and returns a `HTTPoison.Response` struct.

        Spotify.Playlist.featured(country: "US")
        # => %HTTPoison.Response{...}

        iex> Spotify.Playlist.featured_url
        "https://api.spotify.com/v1/browse/featured-playlists"

  https://developer.spotify.com/web-api/user-profile-endpoints/
  """

  @doc """
  Defines the Profile struct.
  """
  defstruct ~w[ birthdate country display_name email external_urls
    followers href id images product type uri ]a

  alias Spotify.Client
  import Helpers

  @doc """
  Get detailed profile information about the current user (including the current user’s username).
  [Spotify Documentation](https://developer.spotify.com/web-api/get-current-users-profile/)

  **Method**: `GET`

  Uses your auth token to find your profile.
      Spotify.Profile.me(conn)
      # => %HTTPoison.Response{..}

      iex> Spotify.Profile.me_url
      "https://api.spotify.com/v1/me"

  """
  def me(conn), do: send_request Client.get(conn, me_url)
  def me_url, do: "https://api.spotify.com/v1/me"

  @doc """
  Get public profile information about a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-profile/)

  **Method**: `GET`

      Spotify.Profile.user(conn, "123")
      # => %HTTPoison.Response{..}

      iex> Spotify.Profile.user_url("123")
      "https://api.spotify.com/v1/users/123"

  """
  def user(conn, user_id), do: send_request Client.get(conn, user_url(user_id))
  def user_url(user_id), do: "https://api.spotify.com/v1/users/#{user_id}"
end
