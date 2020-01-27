defmodule Spotify.CookiesTest do
  use ExUnit.Case
  doctest Spotify.Cookies
  alias Spotify.Cookies

  test "#set_refresh_cookie" do
    conn =
      %Plug.Conn{cookies: %{"spotify_refresh_token" => "foo"}}
      |> Cookies.set_refresh_cookie("token123")

    assert(Cookies.get_refresh_token(conn) == "token123")
  end

  test "#set_access_cookie" do
    conn =
      %Plug.Conn{cookies: %{"spotify_access_token" => "foo"}}
      |> Cookies.set_access_cookie("token123")

    assert(Cookies.get_access_token(conn) == "token123")
  end

  test "#set_expires_in" do
    conn =
      %Plug.Conn{cookies: %{"spotify_expires_in" => "foo"}}
      |> Cookies.set_expires_cookie("token123")

    assert(Cookies.get_expires_in(conn) == "token123")
  end
end
