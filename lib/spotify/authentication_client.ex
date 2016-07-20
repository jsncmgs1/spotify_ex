defmodule AuthenticationClient do
  alias Spotify.Authentication
  import Spotify.Cookies

  @url "https://accounts.spotify.com/api/token"

  def authenticate(conn, params) do
    if get_refresh_cookie(conn) do
      refresh(conn)
    else
      case HTTPoison.request(:post, @url, body_params(params["code"]), Spotify.headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          { _, %{ "access_token" => access_token, "refresh_token" => refresh_token } } = Poison.decode(body)
          conn = conn |> set_cookies(access_token: access_token, refresh_token: refresh_token)
          { conn, %Authentication{access_token: access_token, status: 200} }

        {:ok, %HTTPoison.Response{status_code: status}} ->
          { conn, %Authentication{status: status }}

        {:error, %HTTPoison.Error{reason: reason}} ->
          { conn, %Authentication{error: reason}}
      end
    end

  end

  def refresh(conn) do
    case HTTPoison.request(:post, @url, refresh_body_params(conn), Spotify.headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { _, %{ "access_token" => access_token }} = Poison.decode(body)
        conn = set_access_cookie(conn, access_token)
        { conn, %Authentication{access_token: access_token, status: 200} }
      {:ok, %HTTPoison.Response{status_code: status}} ->
          { conn, %Authentication{status: status }}
    end
  end

  defp refresh_body_params(conn) do
    "grant_type=refresh_token&refresh_token=#{get_refresh_cookie(conn)}"
  end

  defp body_params(code) do
    "grant_type=authorization_code&code=#{code}&redirect_uri=#{Spotify.callback_url}"
  end
end
