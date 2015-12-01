defmodule Spotify.Authentication do
  def call(conn, params) do
    if refresh_token(conn) do
      refresh(conn)
    else
      case HTTPoison.request(:post, authenticate_endpoint, authenticate_body_params(params["code"]), Spotify.headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          { _, %{ "access_token" => access_token, "refresh_token" => refresh_token } } = Poison.decode(body)
          conn = conn |> set_access_cookie(access_token) |> set_refresh_cookie(refresh_token)
          {200 , conn , %{ "access_token" => access_token }}
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          { 404, "Not found :(" }
        {:error, %HTTPoison.Error{reason: reason}} ->
          { 500, reason }
      end
    end
  end

  def refresh_token(conn) do
    conn.cookies["spotify_refresh_token"]
  end

  def refresh(conn) do
    case HTTPoison.request(:post, authenticate_endpoint, refresh_body_params(conn), Spotify.headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { _, %{ "access_token" => access_token }} = Poison.decode(body)
        conn = set_access_cookie(conn, access_token)
        { 200 , conn , %{ "access_token" => access_token }}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {404, "Not found :(" }
    end
  end

  def refresh_body_params(conn) do
    "grant_type=refresh_token&refresh_token=#{refresh_token(conn)}"
  end

  def authenticate_body_params(code) do
    "grant_type=authorization_code&code=#{code}&redirect_uri=#{Spotify.callback_url}"
  end

  def authenticate_endpoint do
    "https://accounts.spotify.com/api/token"
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

  def tokens_present?(conn) do
    !!(get_refresh_cookie(conn) && get_access_cookie(conn))
  end
end
