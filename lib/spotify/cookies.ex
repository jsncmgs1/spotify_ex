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
    |> set_refresh_cookie(credentials.refresh_token)
    |> set_access_cookie(credentials.access_token)
    |> set_expires_cookie(credentials.expires_in)
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
  Sets the expiration date for the access token
  """
  def set_expires_cookie(conn, string)
  def set_expires_cookie(conn, nil), do: conn

  def set_expires_cookie(conn, expires_in) do
    Plug.Conn.put_resp_cookie(conn, "spotify_expires_in", Integer.to_string(expires_in))
  end

  @doc """
  Gets the access token
  """
  def get_access_token(conn)

  def get_access_token(conn) do
    conn.cookies["spotify_access_token"]
  end

  @doc """
  Gets the refresh token
  """
  def get_refresh_token(conn)

  def get_refresh_token(conn) do
    conn.cookies["spotify_refresh_token"]
  end

  @doc """
  Gets the expiration date for the access token
  """
  def get_expires_in(conn)

  def get_expires_in(conn) do
    conn.cookies["spotify_expires_in"]
  end
end
