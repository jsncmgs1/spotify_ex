defmodule Spotify.AuthTest do
  use ExUnit.Case, async: true

  @atoken "access_token"
  @rtoken "refresh_token"
  @auth %Spotify.Auth{access_token: @atoken, refresh_token: @rtoken}

  test "new/2 returns a Spotify.Auth struct when given tokens" do
    assert @auth == Spotify.Auth.new(@atoken, @rtoken)
  end

  describe "new/1 returns a Spotify.Auth struct" do
    test "when given a Plug.Conn" do
      conn = Plug.Test.conn(:post, "/authenticate")
              |> Plug.Conn.fetch_cookies
              |> Plug.Conn.put_resp_cookie("spotify_access_token",  @atoken)
              |> Plug.Conn.put_resp_cookie("spotify_refresh_token", @rtoken)
      assert @auth == Spotify.Auth.new(conn)
    end

    test "when given a Spotify.Auth struct" do
      assert @auth == Spotify.Auth.new(@auth)
    end
  end
end
