defmodule Spotify.Profile do
  @moduledoc """
  Endpoints for retrieving information about a user’s profile.

  There are two functions for each endpoint, one that actually makes the request,
  and one that provides the endpoint:

        Spotify.Playist.create_playlist(conn, "foo", "bar") # makes the POST request.
        Spotify.Playist.create_playlist_url("foo", "bar") # provides the url for the request.

  https://developer.spotify.com/web-api/user-profile-endpoints/
  """

  defstruct ~w[ birthdate country display_name email external_urls
    followers href id images product type uri ]a

  alias Spotify.Client
  use Responder
  import Helpers

  @doc """
  Get detailed profile information about the current user (including the current user’s username).
  [Spotify Documentation](https://developer.spotify.com/web-api/get-current-users-profile/)

  **Method**: `GET`

  Uses your auth token to find your profile.
      Spotify.Profile.me(conn)
      # => { :ok, %Spotify.Profile{..} }
  """
  def me(conn) do
     conn |> Client.get(me_url) |> handle_response
  end

  @doc """
  Get detailed profile information about the current user (including the current user’s username).

      iex> Spotify.Profile.me_url
      "https://api.spotify.com/v1/me"
  """
  def me_url, do: "https://api.spotify.com/v1/me"

  @doc """
  Get public profile information about a Spotify user.
  [Spotify Documentation](https://developer.spotify.com/web-api/get-users-profile/)

  **Method**: `GET`

      Spotify.Profile.user(conn, "123")
      # => { :ok, %Spotify.Profile{..} }
  """
  def user(conn, user_id) do
    url = user_url(user_id)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get public profile information about a Spotify user.

      iex> Spotify.Profile.user_url("123")
      "https://api.spotify.com/v1/users/123"
  """
  def user_url(user_id), do: "https://api.spotify.com/v1/users/#{user_id}"

  @doc """
  Implements the hook expected by the Responder behaviour
  """
  def build_response(body) do
    to_struct(__MODULE__, body)
  end

end
