defmodule DocTest do
  use ExUnit.Case
  alias Spotify.{
    Profile,
    Personalization,
    Playlist
  }

  doctest Profile
  doctest Personalization
  doctest Playlist
end
