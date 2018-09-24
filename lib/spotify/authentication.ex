defmodule Spotify.Authentication do
  @moduledoc """
  Authenticates the Spotify user.

  After your app is authorized, the user must be authenticated.  A redirect
  URL is specified in the config folder.  This is the URL that Spotify
  redirects to after authorization, and should ultimately end up hitting
  this module's `authenticate` function. If the authorization is successful,
  the param `code` will be present.

  If a refresh token still exists, the client will refresh the access token.

  You have the option to pass either a Plug.Conn or a Spotify.Credentials struct into
  these functions. If you pass Conn, the auth tokens will be saved in cookies.
  If you pass Credentials, you will be responsible for persisting the auth tokens
  between requests.
  """
  alias Spotify.{
    AuthenticationError,
    Credentials,
    Cookies
  }

  @doc """
  Authenticates the user

  The authorization code must be present from spotify or an exception
  will be raised.  The token will be refreshed if possible, otherwise
  the app will request new access and request tokens.

  ## Example: ##
      Spotify.authenticate(conn, %{"code" => code})
      # {:ok, conn}

      Spotify.authenticate(conn, %{"not_a_code" => invalid})
      # AuthenticationError, "No code provided by Spotify. Authorize your app again"

      Spotify.authenticate(auth, params)
      # {:ok, auth}
  """
  def authenticate(conn_or_auth, map)

  def authenticate(conn = %Plug.Conn{}, params) do
    {:ok, auth} = conn |> Credentials.new() |> authenticate(params)
    {:ok, Cookies.set_cookies(conn, auth)}
  end

  def authenticate(auth, %{"code" => code}) do
    auth |> body_params(code) |> Spotify.AuthenticationClient.post()
  end

  def authenticate(_, _) do
    raise AuthenticationError, "No code provided by Spotify. Authorize your app again"
  end

  @doc """
  Attempts to refresh your access token if the refresh token exists. Returns
  `:unauthorized` if there is no refresh token.
  """
  def refresh(conn_or_auth)

  def refresh(conn = %Plug.Conn{}) do
    with {:ok, auth} <- conn |> Credentials.new() |> refresh do
      {:ok, Cookies.set_cookies(conn, auth)}
    end
  end

  def refresh(%Credentials{refresh_token: nil}), do: :unauthorized
  def refresh(auth), do: auth |> body_params |> Spotify.AuthenticationClient.post()

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
  def tokens_present?(conn_or_auth)
  def tokens_present?(%Credentials{access_token: nil}), do: false
  def tokens_present?(%Credentials{refresh_token: nil}), do: false
  def tokens_present?(%Credentials{}), do: true
  def tokens_present?(conn), do: conn |> Credentials.new() |> tokens_present?

  @doc false
  def authenticated?(%Credentials{access_token: token}), do: token
  def authenticated?(conn), do: conn |> Credentials.new() |> authenticated?

  @doc false
  def body_params(%Credentials{refresh_token: token}) do
    "grant_type=refresh_token&refresh_token=#{token}"
  end

  @doc false
  def body_params(%Credentials{refresh_token: nil}, code) do
    "grant_type=authorization_code&code=#{code}&redirect_uri=#{Spotify.callback_url()}"
  end

  def body_params(auth, _code), do: body_params(auth)
end
