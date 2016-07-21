defmodule Spotify.Authorization do
  @moduledoc """
  Authorizes your app with Spotify

  Spotify needs to verify your client id, and that your redirect uri
  matches what you set in your app settings (in the Spotify App dashboard).
  This is an external call, url provided by the `url` function.
  """

  @doc """
   If you specified scopes in your config, uses scoped auth.
   Otherwise, unscoped. Use this function to make the redirect to
   Spotify for authorization.

   ## Example:

       defmodule OAuthController do
         # ...

         def authorize do
           redirect conn, external: Spotify.Authorization.url
         end
       end
  """
  def url do
    if scopes != "" do
      scoped_auth
    else
      scopeless_auth
    end
  end

  @doc false
  def scopes do
    Application.get_env(:spotify_ex, :scopes)
     |> Enum.join(" ")
     |> URI.encode
  end

  @doc false
  def scoped_auth do
    "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}&scope=#{scopes}"
  end

  @doc false
  def scopeless_auth do
    "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}"
  end

end
