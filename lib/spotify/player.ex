defmodule Spotify.Player do
  @moduledoc """
  Provides functions for retrieving and manipulating user's current playback.

  https://developer.spotify.com/documentation/web-api/reference/player/
  """

  use Spotify.Responder

  @doc """
  Add an item to the user's playback queue.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/add-to-queue/)

  **Method**: `POST`

  **Optional Params**: `device_id`
  """
  def enqueue(conn, uri, params \\ [])

  @doc """
      iex> Spotify.Player.enqueue_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/queue?device_id=abc"
  """
  def enqueue_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/queue" <> query_string(params)
  end

  @doc """
  Get the user's available devices.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-a-users-available-devices/)

  **Method**: `GET`
  """
  def get_devices(conn)

  @doc """
      iex> Spotify.Player.devices_url
      "https://api.spotify.com/v1/me/player/devices"
  """
  def devices_url do
    "https://api.spotify.com/v1/me/player/devices"
  end

  @doc """
  Get information about the user's playback currently playing context.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-information-about-the-users-current-playback/)

  **Method**: `GET`

  **Optional Params**: `market`, `additional_types`
  """
  def get_current_playback(conn, params \\ [])

  @doc """
      iex> Spotify.Player.player_url(market: "US")
      "https://api.spotify.com/v1/me/player?market=US"
  """
  def player_url(params \\ []) do
    "https://api.spotify.com/v1/me/player" <> query_string(params)
  end

  @doc """
  Get the user's recently played tracks.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-recently-played/)

  **Method**: `GET`

  **Optional Params**: `limit`, `after`, `before`
  """
  def get_recently_played(conn, params \\ [])

  @doc """
      iex> Spotify.Player.recently_played_url(limit: 50)
      "https://api.spotify.com/v1/me/player/recently-played?limit=50"
  """
  def recently_played_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/recently-played" <> query_string(params)
  end

  @doc """
  Get the user's currently playing tracks.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-the-users-currently-playing-track/)

  **Method**: `GET`

  **Optional Params**: `market`, `additional_types`
  """
  def get_currently_playing(conn, params \\ [])

  @doc """
      iex> Spotify.Player.currently_playing_url(market: "US")
      "https://api.spotify.com/v1/me/player/currently-playing?market=US"
  """
  def currently_playing_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/currently-playing" <> query_string(params)
  end

  @doc """
  Pause the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/pause-a-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def pause(conn, params \\ [])

  @doc """
      iex> Spotify.Player.pause_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/pause?device_id=abc"
  """
  def pause_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/pause" <> query_string(params)
  end

  @doc """
  Seek to position in currently playing track.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/seek-to-position-in-currently-playing-track/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def seek(conn, position_ms, params \\ [])

  @doc """
      iex> Spotify.Player.seek_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/seek?device_id=abc"
  """
  def seek_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/seek" <> query_string(params)
  end

  @doc """
  Set repeat mode for the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/set-repeat-mode-on-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def set_repeat(conn, state, params \\ [])

  @doc """
      iex> Spotify.Player.repeat_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/repeat?device_id=abc"
  """
  def repeat_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/repeat" <> query_string(params)
  end

  @doc """
  Set volume for the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/set-volume-for-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def set_volume(conn, volume_percent, params \\ [])

  @doc """
      iex> Spotify.Player.volume_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/volume?device_id=abc"
  """
  def volume_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/volume" <> query_string(params)
  end

  @doc """
  Skip the user's playback to next track.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/skip-users-playback-to-next-track/)

  **Method**: `POST`

  **Optional Params**: `device_id`
  """
  def skip_to_next(conn, params \\ [])

  @doc """
      iex> Spotify.Player.next_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/next?device_id=abc"
  """
  def next_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/next" <> query_string(params)
  end

  @doc """
  Skip the user's playback to previous track.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/skip-users-playback-to-previous-track/)

  **Method**: `POST`

  **Optional Params**: `device_id`
  """
  def skip_to_previous(conn, params \\ [])

  @doc """
      iex> Spotify.Player.previous_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/previous?device_id=abc"
  """
  def previous_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/previous" <> query_string(params)
  end

  @doc """
  Start/resume the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/start-a-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`, `context_uri`, `uris`, `offset`, `position_ms`
  """
  def play(conn, params \\ [])

  @doc """
      iex> Spotify.Player.play_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/play?device_id=abc"
  """
  def play_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/play" <> query_string(params)
  end

  @doc """
  Toggle shuffle for the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/toggle-shuffle-for-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def set_shuffle(conn, state, params \\ [])

  @doc """
      iex> Spotify.Player.shuffle_url(device_id: "abc")
      "https://api.spotify.com/v1/me/player/shuffle?device_id=abc"
  """
  def shuffle_url(params \\ []) do
    "https://api.spotify.com/v1/me/player/shuffle" <> query_string(params)
  end

  @doc """
  Transfer the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/transfer-a-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `play`
  """
  def transfer_playback(conn, device_ids, params \\ [])
end

