defmodule AuthenticationClient do
  @moduledoc false
  import Spotify.Cookies

  def post(conn, params) do
    case AuthRequest.post(params) do
      {:ok, %HTTPoison.Response{status_code: _code, body: body}} ->
        { :ok, response } = Poison.decode(body)
        cookies = get_cookies_from_response(response)
        conn = set_cookies(conn, cookies)
        { :ok, conn }
      {:error, %HTTPoison.Error{reason: reason}} ->
        { :error, reason, conn }
    end
  end
end

defmodule AuthRequest do
  @moduledoc false

  @url "https://accounts.spotify.com/api/token"

  def post(params) do
    HTTPoison.post(@url, params, Spotify.headers)
  end

  def headers do
    [
      {"Authorization", "Basic #{Spotify.encoded_credentials}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end

end
