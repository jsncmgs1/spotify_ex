defmodule Spotify.Authentication.Mock do
  @url Application.get_env(:spotify_ex, :auth_client)

  def call(conn, _) do
    {:ok, %{status_code: 200, body: "foo"}
  end
end
