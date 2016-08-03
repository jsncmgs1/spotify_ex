defmodule Spotify.Follow do
  @moduledoc """
  Follow users or artists
  """

  use Responder
  @behaviour Responder
  import Helpers
  alias Spotify.Client

  @doc """
  Add the current user as a follower of one or more artists or other Spotify users.
  [Spotify Documentation](https://developer.spotify.com/web-api/follow-artists-users/)

  **Required Params**: `type`, `ids`

  **Method**: `PUT`

      Spotify.Follow.follow(conn, type: "artist", ids: "1,4")
      # => :ok

  """
  def follow(conn, params) do
    url = follow_url(params)
    conn |> Client.put(url) |> handle_response
  end

  @doc """
  Add the current user as a follower of one or more artists or other Spotify users.

      iex> Spotify.Follow.follow_url(ids: "1,4", type: "artist")
      "https://api.spotify.com/v1/me/following?ids=1%2C4&type=artist"
  """
  def follow_url(params) do
    "https://api.spotify.com/v1/me/following" <> query_string(params)
  end

  def build_response(body), do: body # The only endpoint has an empty response
end
