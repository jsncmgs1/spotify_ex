defmodule AuthenticationError do
  defexception [:message]

  def exception(_) do
    %AuthenticationError{message: "No code provided by Spotify. Authorize your app again"}
  end
end

defmodule Spotify.Authentication do
  import Spotify.Cookies

  @moduledoc """
    Authenticates the Spotify user.

    After your app is authorized, the user must be authenticated.  A redirect
    URL is specified in the config folder.  This is the URL that Spotify
    redirects to after authorization, and should ultimately end up hitting
    this module's `authenticate` function. If the authorization is successful,
    the param `code` will be present.

    If a refresh token still exists, the client will refresh the access token.
  """

  @doc """
    The authorization code must be present from spotify or an exception
    will be raised.  The token will be refreshed if possible, otherwise
    the app will request new access and request tokens.

    ## Example: ##
      iex> Spotify.authenticate(conn, %{"code" => code})
      iex> # {:ok, "your access token", conn}

      iex> Spotify.authenticate(conn, %{"not_a_code" => invalid})
      iex> AuthenticationError, "No code provided by Spotify. Authorize your app again"
  """
  def authenticate(conn, map)
  def authenticate(conn, %{"code" => code}) do
    if get_refresh_cookie(conn) do
      client.refresh(conn)
    else
      client.authenticate(conn, code)
    end
  end

  def authenticate(_conn, _) do
    raise AuthenticationError, "No code provided by Spotify. Authorize your app again"
  end

  @doc """
    Checks for refresh and access tokens

    ## Example: ##

      defmodule PlayListController do
        plug :check_tokens

        def check_tokens do
          unless Spotify.Authentication.tokens_present?(conn) do
            redirect conn, to: authorization_path(:authorize)
          end
        end
      end
  """
  def tokens_present?(conn) do
    !!(get_refresh_cookie(conn) && get_access_cookie(conn))
  end

  defp client do
    # TODO: Temp fix, setting this in dev/test config results in nil?
    case Mix.env do
      :dev  -> Spotify.AuthenticationClient
      :test -> Spotify.AuthenticationClientMock
    end
  end

end
