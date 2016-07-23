defmodule Spotify.Client do
  @get_headers [ Spotify.token_header ]
  @put_headers [ Spotify.token_header,  {"Content-Type", "application/json"} ]

  def get(url, headers \\ @get_headers) do
    HTTPoison.get(url, headers)
  end

  def put(url, body \\ "", headers \\@put_headers) do
    HTTPoison.put(url, body, headers)
  end
end
