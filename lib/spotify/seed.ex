defmodule Spotify.Seed do
  @moduledoc """
  Spotify can make recommendations by providing seed data.  The response
  contains a seed object.
  """
  defstruct ~w[ afterFilteringSize afterRelinkingSize href id initialPoolSize type ]a
end
