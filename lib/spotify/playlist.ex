defmodule Spotify.Playlist do
  def current_user_playlists(conn) do
    case HTTPoison.get("https://api.spotify.com/v1/users/#{Spotify.current_user}/playlists", headers(conn)) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, %{ "items" => items }} = Poison.decode(body)
          {200, items}
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          { 404, "Not found :(" }
        {:ok, %HTTPoison.Response{status_code: 401, body: _body}} ->
          if Spotify.Authentication.get_refresh_token do
            { 200, conn, %{ "access_token" => access_token }} = Spotify.Authentication.refresh(conn)
            conn = Spotify.Authentication.set_access_cookie(conn, access_token)
            current_user_playlists(conn)
          else
            :authorize
          end
        {:error, %HTTPoison.Error{reason: reason}} ->
          { 500, reason }
    end
  end

  def headers(conn) do
    access_token = conn.cookies["spotify_access_token"]
    [
      {"Authorization", "Bearer #{access_token}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end
end
