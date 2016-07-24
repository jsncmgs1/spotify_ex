defmodule Spotify.Profile do
  defstruct ~w[ birthdate country display_name email external_urls
    followers href id images product type uri ]a

  @moduledoc """
  Endpoints for retrieving information about a user’s profile.

  Each endpoint has normal function which returns the endpoint URL, and a
  bang version which makes the request and returns a `HTTPoison.Response` struct.

        Spotify.Playlist.featured!(country: "US")
        # => %HTTPoison.Response{...}

        Spotify.Playlist.featured
        # => "https://api.spotify.com/v1/browse/featured-playlists"

  https://developer.spotify.com/web-api/user-profile-endpoints/
  """

  alias Spotify.Client

  @doc """
  Get detailed profile information about the current user (including the current user’s username).
  [Spotify Documentation](https://developer.spotify.com/web-api/get-current-users-profile/)

  **Method**: `GET`

  Uses your auth token to find your profile.
      iex> Spotify.Profile.me
      "https://api.spotify.com/v1/me"

  """
  def me, do: "https://api.spotify.com/v1/me"
  def me!, do: Client.get(me)

  @doc """
  Get public profile information about a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-profile/)

  **Method**: `GET`

      iex> Spotify.Profile.user("123")
      "https://api.spotify.com/v1/users/123"

  """
  def user(user_id), do: "https://api.spotify.com/v1/users/#{user_id}"
  def user!(user_id), do: Client.get(user(user_id))
end
