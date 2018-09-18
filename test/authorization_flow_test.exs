defmodule OathAuthorizationFlow do
  use ExUnit.Case
  import Mock
  use Plug.Test

  alias Spotify.{
    Authentication,
    AuthenticationError
  }

  doctest Spotify.Authentication

  defmacro with_auth_mock(block) do
    quote do
      with_mock Spotify.AuthRequest, post: fn params -> AuthenticationClientMock.post(params) end do
        unquote(block)
      end
    end
  end

  describe "posting to Spotify" do
    test "A body with an error raises Authentication error" do
      with_mock Spotify.AuthRequest,
        post: fn _params ->
          AuthenticationClientMock.post(%{"error_description" => "bad client id"})
        end do
        conn = conn(:post, "/authenticate", %{"code" => "valid"})
        conn = Plug.Conn.fetch_cookies(conn)

        assert_raise AuthenticationError, "The Spotify API responded with: Invalid client", fn ->
          Authentication.authenticate(conn, conn.params)
        end
      end
    end
  end

  describe "authentication" do
    test "a successful attemp sets the cookies" do
      with_auth_mock do
        conn = conn(:post, "/authenticate", %{"code" => "valid"})
        conn = Plug.Conn.fetch_cookies(conn)

        assert {:ok, new_conn} = Authentication.authenticate(conn, conn.params)
        assert new_conn.cookies["spotify_access_token"] == "access_token"
        assert new_conn.cookies["spotify_refresh_token"] == "refresh_token"
      end
    end

    test "a failing attempt raises an error" do
      msg = "No code provided by Spotify. Authorize your app again"
      conn = conn(:post, "/authenticate", %{"not_a_code" => "foo"})

      assert_raise AuthenticationError, msg, fn ->
        Authentication.authenticate(conn, conn.params)
      end
    end
  end

  describe "refreshing the access token" do
    test "with a refresh token present" do
      with_auth_mock do
        conn =
          conn(:post, "/authenticate")
          |> Plug.Conn.fetch_cookies()
          |> Plug.Conn.put_resp_cookie("spotify_refresh_token", "refresh_token")

        assert {:ok, new_conn} = Authentication.refresh(conn)
        assert new_conn.cookies["spotify_access_token"] == "access_token"
        assert new_conn.cookies["spotify_refresh_token"] == "refresh_token"
      end
    end

    test "without a refresh token" do
      conn = conn(:post, "/authenticate") |> Plug.Conn.fetch_cookies()
      assert :unauthorized == Authentication.refresh(conn)
    end
  end
end
