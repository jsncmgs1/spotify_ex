defmodule Spotify.Authentication do
  import Spotify.Cookies
  defstruct access_token: nil, refresh_token: nil, status: nil, error: nil

  @client Application.get_env(:spotify_ex, :auth_client)

  def call(conn, params) do
    @client.authenticate(conn, params)
  end


  def tokens_present?(conn) do
    !!(get_refresh_cookie(conn) && get_access_cookie(conn))
  end

end
