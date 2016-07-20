defmodule Spotify.Cookies do
  def set_cookies(conn, refresh_token: refresh_token, access_token: access_token) do
    conn |> set_refresh_cookie(refresh_token) |> set_access_cookie(access_token)
  end

  def set_refresh_cookie(conn, refresh_token) do
    Plug.Conn.put_resp_cookie(conn, "spotify_refresh_token", refresh_token)
  end

  def set_access_cookie(conn, access_token) do
    Plug.Conn.put_resp_cookie(conn, "spotify_access_token", access_token)
  end

  def get_access_cookie(conn) do
    conn.cookies["spotify_access_token"]
  end

  def get_refresh_cookie(conn) do
    conn.cookies["spotify_refresh_token"]
  end
end
