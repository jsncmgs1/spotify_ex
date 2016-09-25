defmodule Spotify.Client do
  @moduledoc false
  alias Spotify.Credentials

  def get(auth, url) do
    HTTPoison.get(url, get_headers(auth))
  end

  def put(auth, url, body \\ "") do
    HTTPoison.put(url, body, put_headers(auth))
  end

  def post(auth, url, body \\ "") do
    HTTPoison.post(url, body, post_headers(auth))
  end

  def delete(auth, url) do
    HTTPoison.delete(url, delete_headers(auth))
  end

  def get_headers(auth) do
    [{"Authorization", "Bearer #{Credentials.new(auth).access_token}" }]
  end

  def put_headers(auth) do
    [ {"Authorization", "Bearer #{Credentials.new(auth).access_token}" },
      {"Content-Type", "application/json"} ]
  end

  def post_headers(auth), do: put_headers(auth)
  def delete_headers(auth), do: get_headers(auth)
end
