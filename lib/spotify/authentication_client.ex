defmodule Spotify.AuthenticationClient do
  @moduledoc false

  alias Spotify.{
    AuthenticationError,
    AuthRequest,
    Credentials
  }

  alias HTTPoison.{
    Error,
    Response
  }

  def post(params) do
    with {:ok, %Response{status_code: _code, body: body}} <- AuthRequest.post(params),
         {:ok, response} <- Poison.decode(body) do
      case response do
        %{"error_description" => error} ->
          raise(AuthenticationError, "The Spotify API responded with: #{error}")

        success_response ->
          {:ok, Credentials.get_tokens_from_response(success_response)}
      end
    else
      {:error, %Error{reason: reason}} ->
        {:error, reason}

      _generic_error ->
        raise(AuthenticationError, "Error parsing response from Spotify")
    end
  end
end
