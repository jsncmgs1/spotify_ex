defmodule Spotify.Auth do
  alias Spotify.Auth
  alias Plug.Conn

  defstruct [:access_token, :refresh_token]

  @doc """
  Returns a Spotify.Auth struct from either a Plug.Conn or a Spotify.Auth struct
  """
  def new(auth = %Auth{}), do: auth
  def new(conn = %Conn{}) do
    conn = Plug.Conn.fetch_cookies(conn)
    access_token = conn.cookies["spotify_access_token"]
    refresh_token = conn.cookies["spotify_refresh_token"]
    Auth.new(access_token, refresh_token)
  end

  @doc "Returns a Spotify.Auth struct given tokens"
  def new(access_token, refresh_token) do
    %Auth{access_token: access_token, refresh_token: refresh_token}
  end

  @doc """
  Returns a Spotify.Auth struct from a parsed response body
  """
  def get_tokens_from_response(map)
  def get_tokens_from_response(response) do
    %Spotify.Auth{refresh_token: response["refresh_token"], access_token: response["access_token"]}
  end
end
