defmodule DocTest do
  use ExUnit.Case

  doctest Spotify.Album
  doctest Spotify.Profile
  doctest Spotify.Personalization
  doctest Spotify.Playlist
  doctest Spotify.Track
  doctest Spotify.Artist
end
