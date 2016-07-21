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
    Authenticates the user

    The authorization code must be present from spotify or an exception
    will be raised.  The token will be refreshed if possible, otherwise
    the app will request new access and request tokens.

    ## Example: ##
      Spotify.authenticate(conn, %{"code" => code})
      # {:ok, "your access token", conn}

      Spotify.authenticate(conn, %{"not_a_code" => invalid})
      # AuthenticationError, "No code provided by Spotify. Authorize your app again"
  """
  def authenticate(conn, map)

  def authenticate(conn, %{"code" => code}) do
    if get_refresh_cookie(conn) do
      AuthenticationClient.post(conn, refresh_body_params(conn))
    else
      AuthenticationClient.post(conn, body_params(code))
    end
  end

  def authenticate(_conn, _) do
    raise AuthenticationError, "No code provided by Spotify. Authorize your app again"
  end


  @doc """
    Attempts to refresh your access token if the connection cookie exits.
  """
  def refresh(conn) do
    if get_refresh_cookie(conn) do
      AuthenticationClient.post(conn, refresh_body_params(conn))
    else
      :unauthorized
    end
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

  @doc false
  def refresh_body_params(conn) do
    "grant_type=refresh_token&refresh_token=#{get_refresh_cookie(conn)}"
  end

  @doc false
  def body_params(code) do
    "grant_type=authorization_code&code=#{code}&redirect_uri=#{Spotify.callback_url}"
  end

end
