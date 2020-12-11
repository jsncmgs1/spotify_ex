defmodule Spotify.Player do
  @moduledoc """
  Provides functions for retrieving and manipulating user's current playback.

  https://developer.spotify.com/documentation/web-api/reference/player/
  """

  use Spotify.Responder
  import Spotify.Helpers

  alias Spotify.{
    Client,
    Context,
    Device,
    Episode,
    History,
    Paging,
    Track
  }

  defstruct ~w[
    actions
    context
    currently_playing_type
    device
    is_playing
    item
    progress_ms
    repeat_state
    shuffle_state
    timestamp
  ]a

  @doc """
  Add an item to the user's playback queue.
  [Spotify Documentation](https://developer.spotify.com/documentation/web-api/reference/player/add-to-queue/)

  **Method**: `POST`

  **Optional Params**: `device_id`
  """
  def enqueue(conn, uri, params \\ []) do
  end

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
  def get_devices(conn) do
    url = devices_url()
    conn |> Client.get(url) |> handle_response()
  end

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
  def get_current_playback(conn, params \\ []) do
    url = player_url(params)
    conn |> Client.get(url) |> handle_response()
  end

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
  def get_recently_played(conn, params \\ []) do
    url = recently_played_url(params)
    conn |> Client.get(url) |> handle_response()
  end

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
  def get_currently_playing(conn, params \\ []) do
  end

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
  def pause(conn, params \\ []) do
  end

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
  def seek(conn, position_ms, params \\ []) do
  end

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
  def set_repeat(conn, state, params \\ []) do
  end

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
  def set_volume(conn, volume_percent, params \\ []) do
  end

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
  def skip_to_next(conn, params \\ []) do
  end

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
  def skip_to_previous(conn, params \\ []) do
  end

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
  def play(conn, params \\ []) do
  end

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
  def set_shuffle(conn, state, params \\ []) do
  end

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
  def transfer_playback(conn, device_ids, params \\ []) do
  end

  def build_response(%{"devices" => devices}) do
    Enum.map(devices, &to_struct(Device, &1))
  end

  def build_response(body = %{"items" => _}) do
    build_paged_histories(body)
  end

  def build_response(body) do
    body =
      body
      |> build_item()
      |> build_device()
      |> build_context()

    to_struct(__MODULE__, body)
  end

  defp build_paged_histories(body) do
    %Paging{
      href: body["href"],
      items: body["items"] |> build_histories(),
      limit: body["limit"],
      next: body["next"],
      offset: body["offset"],
      previous: body["previous"],
      total: body["total"]
    }
  end

  defp build_histories(histories) do
    Enum.map(histories, fn history ->
      %History{
        track: to_struct(Track, history["track"]),
        played_at: history["played_at"],
        context: to_struct(Context, history["context"])
      }
    end)
  end

  defp build_item(body = %{"item" => nil}), do: body

  defp build_item(body = %{"currently_playing_type" => "track"}) do
    Map.update!(body, "item", &to_struct(Track, &1))
  end

  defp build_item(body = %{"currently_playing_type" => "episode"}) do
    Map.update!(body, "item", &to_struct(Episode, &1))
  end

  defp build_device(body = %{"device" => _}) do
    Map.update!(body, "device", &to_struct(Device, &1))
  end

  defp build_context(body = %{"context" => nil}), do: body

  defp build_context(body = %{"context" => _}) do
    Map.update!(body, "context", &to_struct(Context, &1))
  end
end
