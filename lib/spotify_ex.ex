defmodule Spotify do
  def client_id, do: Application.get_env :spotify_ex, :client_id

  def secret_key, do: Application.get_env :spotify_ex, :secret_key

  def callback_url do
    Application.get_env(:spotify_ex, :callback_url) |> URI.encode_www_form
  end

  def encoded_credentials, do: :base64.encode("#{client_id}:#{secret_key}")

end
