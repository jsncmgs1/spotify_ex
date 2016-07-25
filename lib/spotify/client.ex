defmodule Spotify.Client do
  @moduledoc false
  @put_headers [ Spotify.token_header,  {"Content-Type", "application/json"} ]

  def get(conn, url) do
    HTTPoison.get(url, auth_header(conn))
  end

  def put(url, body \\ "", headers \\@put_headers) do
    HTTPoison.put(url, body, headers)
  end

  def post(url, body \\ "", headers \\@put_headers) do
    HTTPoison.post(url, body, headers)
  end

  def delete(url, headers \\ @get_headers) do
    HTTPoison.delete(url, headers)
  end

  def auth_header(conn) do
    [{"Authorization", "Bearer #{conn.cookies["spotify_access_token"]}" }]
  end

end
