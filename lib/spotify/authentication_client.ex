defmodule AuthenticationClient do
  @moduledoc false

  alias HTTPoison.Response
  alias HTTPoison.Error

  def post(params) do
    with {:ok, %Response{status_code: _code, body: body}} <- AuthRequest.post(params),
         {:ok, response} <- Poison.decode(body) do

      case response do
        %{"error_description" => error} ->
          raise(AuthenticationError, "The Spotify API responded with: #{error}")
        success_response ->
          {:ok, Spotify.Credentials.get_tokens_from_response(success_response)}
      end
    else
      {:error, %Error{reason: reason}} ->
        { :error, reason }
      _generic_error ->
        raise(AuthenticationError, "Error parsing response from Spotify")
    end
  end
end

defmodule AuthRequest do
  @moduledoc false

  @url "https://accounts.spotify.com/api/token"

  def post(params) do
    HTTPoison.post(@url, params, headers())
  end

  def headers do
    [
      {"Authorization", "Basic #{Spotify.encoded_credentials}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
  end

end
