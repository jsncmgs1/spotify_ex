defmodule DocTest do
  use ExUnit.Case
  alias Spotify.{
    Profile,
    Personalization,
    Playlist,
    Track
  }

  doctest Profile
  doctest Personalization
  doctest Playlist
  doctest Track
end
