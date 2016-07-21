defmodule AuthenticationClient do
  @moduledoc false

  alias Spotify.Authentication
  import Spotify.Cookies

  @url "https://accounts.spotify.com/api/token"

  def authenticate(conn, code) do
    case HTTPoison.request(:post, @url, body_params(code), Spotify.headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { _, %{ "access_token" => access_token, "refresh_token" => refresh_token } } = Poison.decode(body)
        conn = conn
          |> Plug.Conn.put_status(200)
          |> set_cookies(%{refresh_token: refresh_token, access_token: access_token})
        { :ok, access_token, conn }
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        { :error, body, conn }
      {:error, %HTTPoison.Error{reason: reason}} ->
        { :error, reason, conn }
    end
  end

  def refresh(conn) do
    case HTTPoison.request(:post, @url, refresh_body_params(conn), Spotify.headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { _, %{ "access_token" => access_token }} = Poison.decode(body)
        conn = conn
          |> Plug.Conn.put_status(200)
          |> set_access_cookie(access_token)
        { :ok, access_token, conn }
      {:error, %HTTPoison.Error{reason: reason}} ->
        { :error, reason, conn }
    end
  end

  defp refresh_body_params(conn) do
    "grant_type=refresh_token&refresh_token=#{get_refresh_cookie(conn)}"
  end

  defp body_params(code) do
    "grant_type=authorization_code&code=#{code}&redirect_uri=#{Spotify.callback_url}"
  end
end
