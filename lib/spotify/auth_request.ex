defmodule Spotify.AuthRequest do
  @moduledoc false

  @url "https://accounts.spotify.com/api/token"

  def post(params) do
    HTTPoison.post(@url, params, headers())
  end

  def headers do
    [
      {"Authorization", "Basic #{Spotify.encoded_credentials()}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end
end
