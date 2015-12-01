defmodule SpotifyTest do
  use ExUnit.Case
  doctest Spotify

  test "#client_id" do
    assert Application.get_env(:spotify_ex, :client_id) == Spotify.client_id
  end

  test "#secret_key" do
    assert Application.get_env(:spotify_ex, :secret_key) == Spotify.secret_key
  end

  test "#redirect_callack" do
    assert Spotify.callback_url == Application.get_env(:spotify_ex, :callback_url) |> URI.encode_www_form
  end

  test "encoded_credentials" do
    assert Spotify.encoded_credentials == :base64.encode("#{Spotify.client_id}:#{Spotify.secret_key}")
  end
end
