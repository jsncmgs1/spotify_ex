defmodule Spotify.Cookies do
  @moduledoc """
  Convenience setters and getters for auth cookies
  """

  @doc """
  Sets the refresh token and access token and returns the conn.

  ## Example:
      credentials = %Spotify.Credentials{refresh_token: rt, access_token: at}
      Spotify.Cookies.set_cookies(conn, credentials)
  """
  def set_cookies(conn, credentials) do
    conn
    |> Plug.Conn.put_status(200)
    |> set_refresh_cookie(credentials.refresh_token)
    |> set_access_cookie(credentials.access_token)
  end

  @doc """
  Sets the refresh token
  """
  def set_refresh_cookie(conn, string)

  def set_refresh_cookie(conn, nil), do: conn

  def set_refresh_cookie(conn, refresh_token) do
    Plug.Conn.put_resp_cookie(conn, "spotify_refresh_token", refresh_token)
  end

  @doc """
  Sets the access token
  """
  def set_access_cookie(conn, string)
  def set_access_cookie(conn, nil), do: conn

  def set_access_cookie(conn, access_token) do
    Plug.Conn.put_resp_cookie(conn, "spotify_access_token", access_token)
  end

  @doc """
  Gets the access token
  """
  def get_access_token(conn)

  def get_access_token(conn) do
    conn.cookies["spotify_access_token"]
  end

  @doc """
  Gets the access token
  """
  def get_refresh_token(conn)

  def get_refresh_token(conn) do
    conn.cookies["spotify_refresh_token"]
  end
end
