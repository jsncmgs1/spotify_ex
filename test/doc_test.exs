defmodule DocTest do
  use ExUnit.Case
  alias Spotify.{
    Album,
    Profile,
    Personalization,
    Playlist,
    Track
  }

  doctest Album
  doctest Profile
  doctest Personalization
  doctest Playlist
  doctest Track
end
