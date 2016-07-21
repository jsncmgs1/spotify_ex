defmodule Spotify do
  @moduledoc false

  def client_id, do: Application.get_env :spotify_ex, :client_id
  def secret_key, do: Application.get_env :spotify_ex, :secret_key
  def current_user, do: Application.get_env :spotify_ex, :user_id

  def callback_url do
    Application.get_env(:spotify_ex, :callback_url) |> URI.encode_www_form
  end

  def encoded_credentials, do: :base64.encode("#{client_id}:#{secret_key}")

  def headers do
    [
      {"Authorization", "Basic #{encoded_credentials}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end
end
