defmodule Helpers do
  def query_string([]), do: ""
  def query_string(params), do: "?" <> URI.encode_query(params)

  def to_struct(kind, attrs) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

  defmacro send_request(request) do
    quote do
      case unquote(request) do
        { :ok, %HTTPoison.Response{ status_code: 200, body: body } } ->
          { :ok, to_struct(__MODULE__, Poison.decode!(body)) }
        rest -> rest
      end
    end
  end
end
