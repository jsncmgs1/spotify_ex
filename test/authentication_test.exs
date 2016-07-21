defmodule Spotify.AuthenticationTest do
  use ExUnit.Case
  alias Spotify.Authentication
  doctest Spotify.Authentication

  describe ".authenticate" do
    test "successful authentication" do
      expected = Authentication.authenticate(Plug.Conn, %{"code" => "bar"})
      actual = {:ok, "access_token", Plug.Conn}
      assert expected == actual
    end

    test "Spotify does not send a `code` param in the redirect URL" do
      assert_raise AuthenticationError, "No code provided by Spotify. Authorize your app again", fn ->
        Authentication.authenticate(Plug.Conn, %{"not_a_code" => "invalid"})
      end
    end
  end

end
