defmodule Spotify.Responder do
  @moduledoc """
  Receives http responses from the client and handles them accordingly.

  Spotify API modules (Playlist, Album, etc) `use Spotify.Responder`. When a request
  is made they give the endpoint URL to the Client, which makes the request,
  and pass the response to `handle_response`. Each API module must build
  appropriate responses, so they add Spotify.Responder as a behaviour, and implement
  the `build_response/1` function.
  """

  @callback build_response(map) :: any

  defmacro __using__(_) do
    quote do
      def handle_response({:ok, %HTTPoison.Response{status_code: code, body: ""}})
          when code in 200..299,
          do: :ok

      # special handling for 'too many requests' status
      # in order to know when to retry
      def handle_response(
            {message, %HTTPoison.Response{status_code: 429, body: body, headers: headers}}
          ) do
        {retry_after, ""} =
          headers
          |> Enum.find(fn {key, value} -> String.downcase(key) == "retry-after" end)
          |> Kernel.elem(1)
          |> Integer.parse()

        {message, Map.put(Poison.decode!(body), "meta", %{"retry_after" => retry_after})}
      end

      def handle_response({message, %HTTPoison.Response{status_code: code, body: body}})
          when code in 400..499 do
        {message, Poison.decode!(body)}
      end

      def handle_response({:ok, %HTTPoison.Response{status_code: _code, body: body}}) do
        response = body |> Poison.decode!() |> build_response

        {:ok, response}
      end

      def handle_response({:error, %HTTPoison.Error{reason: reason}}) do
        {:error, reason}
      end
    end
  end
end
