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

  def queue_url do
    "https://api.spotify.com/v1/me/player/queue"
  end

  @doc """
  Get the user's available devices.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-a-users-available-devices/)

  **Method**: `GET`
  """
  def get_devices(conn)

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

  def player_url do
    "https://api.spotify.com/v1/me/player"
  end

  @doc """
  Get the user's recently played tracks.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-recently-played/)

  **Method**: `GET`

  **Optional Params**: `limit`, `after`, `before`
  """
  def get_recently_played(conn, params \\ [])

  def recently_played_url do
    "https://api.spotify.com/v1/me/player/recently-played"
  end

  @doc """
  Get the user's currently playing tracks.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/get-the-users-currently-playing-track/)

  **Method**: `GET`

  **Optional Params**: `market`, `additional_types`
  """
  def get_currently_playing(conn, params \\ [])

  def currently_playing_url do
    "https://api.spotify.com/v1/me/player/currently-playing"
  end

  @doc """
  Pause the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/pause-a-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def pause(conn, params \\ [])

  def pause_url do
    "https://api.spotify.com/v1/me/player/pause"
  end

  @doc """
  Seek to position in currently playing track.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/seek-to-position-in-currently-playing-track/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def seek(conn, position_ms, params \\ [])

  def seek_url do
    "https://api.spotify.com/v1/me/player/seek"
  end

  @doc """
  Set repeat mode for the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/set-repeat-mode-on-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def set_repeat(conn, state, params \\ [])

  def repeat_url do
    "https://api.spotify.com/v1/me/player/repeat"
  end

  @doc """
  Set volume for the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/set-volume-for-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def set_volume(conn, volume_percent, params \\ [])

  def volume_url do
    "https://api.spotify.com/v1/me/player/volume"
  end

  @doc """
  Skip the user's playback to next track.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/skip-users-playback-to-next-track/)

  **Method**: `POST`

  **Optional Params**: `device_id`
  """
  def skip_to_next(conn, params \\ [])

  def next_url do
    "https://api.spotify.com/v1/me/player/next"
  end

  @doc """
  Skip the user's playback to previous track.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/skip-users-playback-to-previous-track/)

  **Method**: `POST`

  **Optional Params**: `device_id`
  """
  def skip_to_previous(conn, params \\ [])

  def previous_url do
    "https://api.spotify.com/v1/me/player/previous"
  end

  @doc """
  Start/resume the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/start-a-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`, `context_uri`, `uris`, `offset`, `position_ms`
  """
  def play(conn, params \\ [])

  def play_url do
    "https://api.spotify.com/v1/me/player/play"
  end

  @doc """
  Toggle shuffle for the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/toggle-shuffle-for-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `device_id`
  """
  def set_shuffle(conn, state, params \\ [])

  def shuffle_url do
    "https://api.spotify.com/v1/me/player/shuffle"
  end

  @doc """
  Transfer the user's playback.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/transfer-a-users-playback/)

  **Method**: `PUT`

  **Optional Params**: `play`
  """
  def transfer_playback(conn, device_ids, params \\ [])
end

