defmodule Spotify.CredentialsTest do
  use ExUnit.Case, async: true

  @atoken "access_token"
  @rtoken "refresh_token"
  @expiration "expiration_date"
  @creds %Spotify.Credentials{access_token: @atoken, refresh_token: @rtoken, expires_in: @expiration}

  test "new/3 returns a Spotify.Credentials struct when given tokens and expiration date" do
    assert @creds == Spotify.Credentials.new(@atoken, @rtoken, @expiration)
  end

  test "new/2 returns a Spotify.Credentials struct when given tokens" do
    creds = %Spotify.Credentials{access_token: @atoken, refresh_token: @rtoken}
    assert creds = Spotify.Credentials.new(@atoken, @rtoken)
  end

  describe "new/1 returns a Spotify.Credentials struct" do
    test "when given a Plug.Conn" do
      conn =
        Plug.Test.conn(:post, "/authenticate")
        |> Plug.Conn.fetch_cookies()
        |> Plug.Conn.put_resp_cookie("spotify_access_token", @atoken)
        |> Plug.Conn.put_resp_cookie("spotify_refresh_token", @rtoken)

      assert @creds == Spotify.Credentials.new(conn)
    end

    test "when given a Spotify.Credentials struct" do
      assert @creds == Spotify.Credentials.new(@creds)
    end
  end

  test "get_tokens_from_response/1 returns a Spotify.Credentials struct" do
    response = %{"access_token" => @atoken, "refresh_token" => @rtoken, @expiration => "expires_in"}
    assert @creds == Spotify.Credentials.get_tokens_from_response(response)
  end
end
