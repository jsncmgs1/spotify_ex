defmodule Spotify.Client do
  @headers Spotify.token_header

  def get(url, headers \\ @headers) do
    HTTPoison.get(url, headers)
  end
end
