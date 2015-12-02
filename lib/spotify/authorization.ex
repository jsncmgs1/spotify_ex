defmodule Spotify.Authorization do
  def call do
    if String.length(scopes) > 0 do
      auth_with_scopes
    else
      scopeless_auth
    end
  end

  defp auth_with_scopes do
    "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}&scopes=#{scopes}"
  end

  defp scopeless_auth do
    "https://accounts.spotify.com/authorize?client_id=#{Spotify.client_id}&response_type=code&redirect_uri=#{Spotify.callback_url}"
  end

  def scopes do
    Application.get_env(:spotify_ex, :scopes)
     |> Enum.join(" ")
     |> URI.encode
  end
end
