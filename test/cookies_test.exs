defmodule SpotifyCookiesTest do
  use ExUnit.Case
  doctest Spotify.Cookies

  test "#get_access_token" do
    conn = %Plug.Conn{cookies: %{ "spotify_access_token" => "token123" }}
    assert(Spotify.Cookies.get_access_token(conn) == "token123")
  end

  test "#get_refresh_cookie" do
    conn = %Plug.Conn{cookies: %{ "spotify_refresh_token" => "token123" }}
    assert(Spotify.Cookies.get_refresh_token(conn) == "token123")
  end

  test "#set_refresh_cookie" do
    conn =
      %Plug.Conn{cookies: %{ "spotify_refresh_token" => "foo" }}
      |> Spotify.Cookies.set_refresh_cookie("token123")
    assert(Spotify.Cookies.get_refresh_token(conn) == "token123")
  end

  test "#set_access_cookie" do
    conn =
      %Plug.Conn{cookies: %{"spotify_access_token" => "foo"}}
      |> Spotify.Cookies.set_access_cookie("token123")
    assert(Spotify.Cookies.get_access_token(conn) == "token123")
  end

end
