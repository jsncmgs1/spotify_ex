defmodule PagingTest do
  use ExUnit.Case

  test "%Paging{}" do
    expected = ~w[ cursor href items limit next offset previous total ]a
    actual = %Paging{} |> Map.from_struct |> Map.keys

    assert actual == expected
  end

  test "response/2" do
    collection = [%Spotify.Playlist{}]
    actual = Paging.response(%{}, collection)
    expected = %Paging{items: collection}

    assert actual == expected
  end
end
