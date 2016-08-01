defmodule Responder do
  @moduledoc """
  Recieves http responses from the client and handles them accordingly.

  Spotify API modules (Playlist, Album, etc) `use Responder`. When a request is made they giv the endpoint URL to the Client, which makes the request, and pass the response to `handle_response`. Each API module must build appropriate responses, so they add Responder as a behaviour, and implement the `build_response/1` function.
  """

  @callback build_response(map) :: any

  defmacro __using__(_) do
    quote do
      def handle_response({ :ok, %HTTPoison.Response{ status_code: code, body: "" }})
        when code in [ 200, 201 ] do
          :ok
        end

      def handle_response({ message, %HTTPoison.Response{ status_code: code, body: body }})
      when code in 400..499 do
        { message, Poison.decode!(body)}
      end

      @doc false
      def handle_response({ :ok, %HTTPoison.Response{ status_code: _code, body: body }}) do
        response = body |> Poison.decode! |> build_response

        { :ok, response }
      end

    end
  end
end
