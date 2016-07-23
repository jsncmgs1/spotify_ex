defmodule Spotify.Client do
  @moduledoc false
  @get_headers [ Spotify.token_header ]
  @put_headers [ Spotify.token_header,  {"Content-Type", "application/json"} ]

  def get(url, headers \\ @get_headers) do
    HTTPoison.get(url, headers)
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
end
