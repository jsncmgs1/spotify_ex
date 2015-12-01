defmodule Spotify.Authentication do
  def refresh_body_params(refresh_token) do
    "grant_type=refresh_token&refresh_token=#{refresh_token}"
  end

  def authenticate_body_params(code) do
    callback_url = Spotify.callback_url
    "grant_type=authorization_code&code=#{code}&redirect_uri=#{Spotify.callback_url}"
  end

  def authenticate_endpoint do
    "https://accounts.spotify.com/api/token"
  end

  def headers do
    [
      {"Authorization", "Basic #{Spotify.encoded_credentials}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end

  def authenticate(conn, params) do
    case HTTPoison.request(:post, authenticate_endpoint, authenticate_body_params(params["code"]), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { _, %{ "access_token" => access_token } } = Poison.decode(body)
        {200 , Plug.Conn.put_resp_cookie(conn, "_sat", access_token), %{ "access_token" => access_token }}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        { 404, "Not found :(" }
      {:error, %HTTPoison.Error{reason: reason}} ->
        { 500, reason }
    end
  end

  def request_access_token(conn, refresh_token) do
    case HTTPoison.request(:post, authenticate_endpoint, refresh_body_params(refresh_token), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { 200, body }
      {:error, %HTTPoison.Error{reason: reason}} ->
        { 500, reason }
    end
  end
end
