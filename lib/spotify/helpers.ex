defmodule Helpers do
  @moduledoc false

  def query_string([]), do: ""
  def query_string(params), do: "?" <> URI.encode_query(params)

  @doc """
  Converts a map of string keys to a map of atoms and turns it into a struct
  """
  def to_struct(kind, attrs) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

end

