defmodule DocTest do
  use ExUnit.Case

  doctest Spotify.Album
  doctest Spotify.Artist
  doctest Spotify.Category
  doctest Spotify.Personalization
  doctest Spotify.Recommendation
  doctest Spotify.Playlist
  doctest Spotify.Profile
  doctest Spotify.Search
  doctest Spotify.Track
end
