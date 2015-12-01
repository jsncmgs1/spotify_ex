defmodule SpotifyAuthenticationTest do
  use ExUnit.Case
  doctest Spotify.Authentication

  test "#authenticate_endpoint" do
    assert(Spotify.Authentication.authenticate_endpoint == "https://accounts.spotify.com/api/token")
  end

  test "#refresh_body_params" do
    conn = %Plug.Conn{cookies: %{ "spotify_refresh_token" => "token123" }}

    assert(Spotify.Authentication.refresh_body_params(conn) ==
    "grant_type=refresh_token&refresh_token=token123")
  end

  test "#authenticate_body_params" do
    code = "code123"
    redirect_uri = "http%3A%2F%2Flocalhost%3A4200%2Fauthenticate"

    assert(Spotify.Authentication.authenticate_body_params(code) == "grant_type=authorization_code&code=#{code}&redirect_uri=#{redirect_uri}")
  end

  test "#get_access_cookie" do
    conn = %Plug.Conn{cookies: %{ "spotify_access_token" => "token123" }}
    assert(Spotify.Authentication.get_access_cookie(conn) == "token123")
  end

  test "#get_refresh_cookie" do
    conn = %Plug.Conn{cookies: %{ "spotify_refresh_token" => "token123" }}
    assert(Spotify.Authentication.get_refresh_cookie(conn) == "token123")
  end

  test "#set_refresh_cookie" do
    conn =
      %Plug.Conn{cookies: %{ "spotify_refresh_token" => "foo" }}
      |> Spotify.Authentication.set_refresh_cookie("token123")
    assert(Spotify.Authentication.get_refresh_cookie(conn) == "token123")
  end

  test "#set_access_cookie" do
    conn =
      %Plug.Conn{cookies: %{"spotify_access_token" => "foo"}}
      |> Spotify.Authentication.set_access_cookie("token123")
    assert(Spotify.Authentication.get_access_cookie(conn) == "token123")
  end

end
