defmodule Spotify.Category do
  @moduledoc false

  use Responder
  @behaviour Responder
  import Helpers
  alias Spotify.{Category, Client}

  defstruct ~w[href icons id name]a

  @doc """
  Get a list of categories used to tag items in Spotify
  [Spotify Documentation](https://developer.spotify.com/web-api/get-list-categories/)

  **Method**: `GET`

  **Optional Params**: `country`, `locale`, `limit`, `offset`

      Spotify.Category.get_categories(conn, params)
      # => { :ok, %Paging{items: [%Category{}, ...]} }
  """
  def get_categories(conn, params \\ []) do
    url = get_categories_url(params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get a list of categories used to tag items in Spotify

    iex> Spotify.Category.get_categories_url(country: "US")
    "https://api.spotify.com/v1/browse/categories?country=US"
  """
  def get_categories_url(params \\ []) do
    "https://api.spotify.com/v1/browse/categories" <> query_string(params)
  end

  @doc """
  Get a single category used to tag items in Spotify
  [Spotify Documentation](https://developer.spotify.com/web-api/get-category/)

  **Method**: `GET`

  **Optional Params**: `country`, `locale`

      Spotify.Category.get_category(conn, id)
      # => {:ok, %Category{}}
  """
  def get_category(conn, id, params \\ []) do
    url = get_category_url(id, params)
    conn |> Client.get(url) |> handle_response
  end

  @doc """
  Get a single category used to tag items in Spotify

    iex> Spotify.Category.get_category_url("4")
    "https://api.spotify.com/v1/browse/categories/4"
  """
  def get_category_url(id, params \\ []) do
    "https://api.spotify.com/v1/browse/categories/#{id}" <> query_string(params)
  end


  def build_response(body) do
    case body do
      %{ "categories" => categories } -> build_categories(body, categories["items"])
      category -> to_struct(Category, category)
    end
  end

  def build_categories(body, categories) do
    categories = Enum.map(categories, &to_struct(Category, &1))
    Paging.response(body, categories)
  end

end
