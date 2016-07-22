defmodule Spotify.Profile do
  @moduledoc """
  Endpoints for retrieving information about a user’s profile.

  https://developer.spotify.com/web-api/user-profile-endpoints/
  """

  @doc """
  Get detailed profile information about the current user (including the current user’s username).
  [Spotify Documentation](https://developer.spotify.com/web-api/get-current-users-profile/)

  **Method**: `GET`

  Uses your auth token to find your profile.
      iex> Spotify.Profile.me
      "https://api.spotify.com/v1/me"

  """
  def me, do: "https://api.spotify.com/v1/me"

  @doc """
  Get public profile information about a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-profile/)

  **Method**: `GET`

      iex> Spotify.Profile.user("123")
      "https://api.spotify.com/v1/users/123"

  """
  def user(user_id), do: "https://api.spotify.com/v1/users/#{user_id}"
end
