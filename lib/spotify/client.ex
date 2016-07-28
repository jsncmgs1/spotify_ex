defmodule Spotify.Client do
  @moduledoc false

  def get(conn, url) do
    HTTPoison.get(url, get_headers(conn))
  end

  def put(conn, url, body \\ "") do
    HTTPoison.put(url, body, put_headers(conn))
  end

  def post(conn, url, body \\ "") do
    HTTPoison.post(url, body, post_headers(conn))
  end

  def delete(url, headers \\ @get_headers) do
    HTTPoison.delete(url, headers)
  end

  def get_headers(conn) do
    [{"Authorization", "Bearer #{conn.cookies["spotify_access_token"]}" }]
  end

  def put_headers(conn) do
    [ {"Authorization", "Bearer #{conn.cookies["spotify_access_token"]}" },
      {"Content-Type", "application/json"} ]
  end

  def post_headers(conn), do: put_headers(conn)
  def delete_headers(conn), do: get_headers(conn)
end
