defmodule Spotify.AuthenticationClientMock do
  def authenticate(conn, code) do
    {:ok, "access_token", Plug.Conn}
  end
end
