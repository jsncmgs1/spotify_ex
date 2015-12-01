defmodule SpotifyAuthenticationTest do
  use ExUnit.Case
  doctest Spotify.Authentication

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
