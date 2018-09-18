defmodule Spotify.AuthRequestTest do
  use ExUnit.Case

  test "headers/0" do
    headers = [
      {"Authorization", "Basic #{Spotify.encoded_credentials()}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    assert(Spotify.AuthRequest.headers() == headers)
  end
end
