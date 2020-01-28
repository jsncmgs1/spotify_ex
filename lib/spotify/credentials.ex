defmodule Spotify.Credentials do
  @moduledoc """
  Provides a struct to hold token credentials from Spotify.

  These consist of an access token, used to authenticate requests to the Spotify
  web API, as well as a refresh token, used to request a new access token when
  it expires.

  You can use this struct in the place of a `Plug.Conn` struct anywhere in this
  library's functions with one caveat: If you use a `Plug.Conn`, these tokens
  will be persisted for you in browser cookies. However, if you choose to use
  `Spotify.Credentials`, it will be your responsibility to persist this data
  between uses of the library's functions. This is convenient if your use case
  involves using this library in a situation where you don't have access to a
  `Plug.Conn` or a browser/cookie system.

  ## Example:

      defmodule SpotifyExample do
        @moduledoc "This example uses an `Agent` to persist the tokens"

        @doc "The `Agent` is started with an empty `Credentials` struct"
        def start_link do
          Agent.start_link(fn -> %Spotify.Credentials{} end, name: CredStore)
        end

        defp get_creds, do: Agent.get(CredStore, &(&1))

        defp put_creds(creds), do: Agent.update(CredStore, fn(_) -> creds end)

        @doc "Used to link the user to Spotify to kick off the auth process"
        def auth_url, do: Spotify.Authorization.url

        @doc "`params` are passed to your callback endpoint from Spotify"
        def authenticate(params) do
          creds = get_creds()
          {:ok, new_creds} = Spotify.Authentication.authenticate(creds, params)
          put_creds(new_creds) # make sure to persist the credentials for later!
        end

        @doc "Use the credentials to access the Spotify API through the library"
        def track(id) do
          credentials = get_creds()
          {:ok, track} = Track.get_track(credentials, id)
          track
        end
      end
  """
  alias Spotify.Credentials

  defstruct ~w[
    access_token
    refresh_token
    expires_in
  ]a

  @doc """
  Returns a Spotify.Credentials struct from either a Plug.Conn or a Spotify.Credentials struct
  """
  def new(conn_or_credentials)
  def new(creds = %Credentials{}), do: creds

  def new(conn = %Plug.Conn{}) do
    conn = Plug.Conn.fetch_cookies(conn)
    access_token = conn.cookies["spotify_access_token"]
    refresh_token = conn.cookies["spotify_refresh_token"]
    expires_at = conn.cookies["spotify_expires_in"]
    Credentials.new(access_token, refresh_token, expires_at)
  end

  def new(access_token, refresh_token, expires_in) do
    %Credentials{access_token: access_token, refresh_token: refresh_token, expires_in: expires_in}
  end

  @doc """
  Returns a Spotify.Credentials struct given tokens
  """
  def new(access_token, refresh_token) do
    %Credentials{access_token: access_token, refresh_token: refresh_token}
  end

  @doc """
  Returns a Spotify.Credentials struct from a parsed response body
  """
  def get_tokens_from_response(map)

  def get_tokens_from_response(response) do
    Credentials.new(response["access_token"], response["refresh_token"], response["expires_in"])
  end
end
