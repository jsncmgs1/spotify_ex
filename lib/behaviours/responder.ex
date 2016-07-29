defmodule Responder do
  @moduledoc false
  @callback build_response(map) :: any

  defmacro __using__(_) do
    quote do
      def handle_response({ :ok, %HTTPoison.Response{ status_code: 200, body: "" }}) do
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
