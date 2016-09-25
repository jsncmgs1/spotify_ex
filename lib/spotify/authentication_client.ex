defmodule AuthenticationClient do
  @moduledoc false

  def post(params) do
    case AuthRequest.post(params) do
      {:ok, %HTTPoison.Response{status_code: _code, body: body}} ->
        with {:ok, response} <- Poison.decode(body) do
          {:ok, Spotify.Credentials.get_tokens_from_response(response)}
        else
          _unmatched ->
            raise(AuthenticationError, "Error parsing response from Spotify")
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        { :error, reason }
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
