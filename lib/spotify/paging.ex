defmodule Paging do
  @moduledoc false

  import Helpers
  defstruct ~w[ href items limit next offset previous total ]a

  def response(body, items) do
    to_struct(__MODULE__, body) |> Map.put(:items, items)
  end
end
