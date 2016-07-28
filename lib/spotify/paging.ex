defmodule Paging do
  @moduledoc """
  Spotify wraps collections in a paging object in order to handle pagination.
  Requesting a collection will send the collection back in the `items` key,
  along with the paging links.
  """

  import Helpers

  @def """
  Paging Struct.  Requested Collections are stored in `:items`
  """
  defstruct ~w[ href items limit next offset previous total ]a

  def response(body, items) do
    to_struct(__MODULE__, body) |> Map.put(:items, items)
  end
end
