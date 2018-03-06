defmodule Spotify.Client do
  @moduledoc false

  def get(conn_or_creds, url) do
    HTTPoison.get(url, get_headers(conn_or_creds))
  end

  def put(conn_or_creds, url, body \\ "") do
    HTTPoison.put(url, body, put_headers(conn_or_creds))
  end

  def post(conn_or_creds, url, body \\ "") do
    HTTPoison.post(url, body, post_headers(conn_or_creds))
  end

  def delete(conn_or_creds, url) do
    HTTPoison.delete(url, delete_headers(conn_or_creds))
  end

  def get_headers(conn_or_creds) do
    [{"Authorization", "Bearer #{access_token(conn_or_creds)}"}]
  end

  def put_headers(conn_or_creds) do
    [
      {"Authorization", "Bearer #{access_token(conn_or_creds)}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp access_token(conn_or_creds) do
    Spotify.Credentials.new(conn_or_creds).access_token
  end

  def post_headers(conn_or_creds), do: put_headers(conn_or_creds)
  def delete_headers(conn_or_creds), do: get_headers(conn_or_creds)
end
