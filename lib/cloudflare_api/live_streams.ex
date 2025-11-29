defmodule CloudflareApi.LiveStreams do
  @moduledoc ~S"""
  Manage Realtime Kit livestreams, meeting livestreaming sessions, and stream keys.
  """

  @doc ~S"""
  List live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.list(client, "account_id", "app_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(livestreams_path(account_id, app_id) <> query(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.create(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(livestreams_path(account_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get session for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.get_session(client, "account_id", "app_id", "livestream_session_id")
      {:ok, %{"id" => "example"}}

  """

  def get_session(client, account_id, app_id, livestream_session_id) do
    c(client)
    |> Tesla.get(base(account_id, app_id) <> "/livestreams/sessions/#{livestream_session_id}")
    |> handle_response()
  end

  @doc ~S"""
  Get live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.get(client, "account_id", "app_id", "livestream_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id, livestream_id, opts \\ []) do
    c(client)
    |> Tesla.get(base(account_id, app_id) <> "/livestreams/#{livestream_id}" <> query(opts))
    |> handle_response()
  end

  @doc ~S"""
  Get active session for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.get_active_session(client, "account_id", "app_id", "livestream_id")
      {:ok, %{"id" => "example"}}

  """

  def get_active_session(client, account_id, app_id, livestream_id) do
    c(client)
    |> Tesla.get(
      base(account_id, app_id) <> "/livestreams/#{livestream_id}/active-livestream-session"
    )
    |> handle_response()
  end

  @doc ~S"""
  Disable live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.disable(client, "account_id", "app_id", "livestream_id")
      {:ok, %{"id" => "example"}}

  """

  def disable(client, account_id, app_id, livestream_id) do
    c(client)
    |> Tesla.put(
      base(account_id, app_id) <> "/livestreams/#{livestream_id}/disable",
      %{}
    )
    |> handle_response()
  end

  @doc ~S"""
  Enable live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.enable(client, "account_id", "app_id", "livestream_id")
      {:ok, %{"id" => "example"}}

  """

  def enable(client, account_id, app_id, livestream_id) do
    c(client)
    |> Tesla.put(
      base(account_id, app_id) <> "/livestreams/#{livestream_id}/enable",
      %{}
    )
    |> handle_response()
  end

  @doc ~S"""
  Reset stream key for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.reset_stream_key(client, "account_id", "app_id", "livestream_id")
      {:ok, %{"id" => "example"}}

  """

  def reset_stream_key(client, account_id, app_id, livestream_id) do
    c(client)
    |> Tesla.post(
      base(account_id, app_id) <> "/livestreams/#{livestream_id}/reset-stream-key",
      %{}
    )
    |> handle_response()
  end

  @doc ~S"""
  Get meeting active for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.get_meeting_active(client, "account_id", "app_id", "meeting_id")
      {:ok, %{"id" => "example"}}

  """

  def get_meeting_active(client, account_id, app_id, meeting_id) do
    c(client)
    |> Tesla.get(meetings_base(account_id, app_id, meeting_id) <> "/active-livestream")
    |> handle_response()
  end

  @doc ~S"""
  Stop meeting for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.stop_meeting(client, "account_id", "app_id", "meeting_id")
      {:ok, %{"id" => "example"}}

  """

  def stop_meeting(client, account_id, app_id, meeting_id) do
    c(client)
    |> Tesla.post(
      meetings_base(account_id, app_id, meeting_id) <> "/active-livestream/stop",
      %{}
    )
    |> handle_response()
  end

  @doc ~S"""
  Get meeting livestream for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.get_meeting_livestream(client, "account_id", "app_id", "meeting_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_meeting_livestream(client, account_id, app_id, meeting_id, opts \\ []) do
    c(client)
    |> Tesla.get(meetings_base(account_id, app_id, meeting_id) <> "/livestream" <> query(opts))
    |> handle_response()
  end

  @doc ~S"""
  Start meeting livestream for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.start_meeting_livestream(client, "account_id", "app_id", "meeting_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def start_meeting_livestream(client, account_id, app_id, meeting_id, params)
      when is_map(params) do
    c(client)
    |> Tesla.post(
      meetings_base(account_id, app_id, meeting_id) <> "/livestreams",
      params
    )
    |> handle_response()
  end

  @doc ~S"""
  Get session livestreams for live streams.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LiveStreams.get_session_livestreams(client, "account_id", "app_id", "session_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_session_livestreams(client, account_id, app_id, session_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      base(account_id, app_id) <> "/sessions/#{session_id}/livestream-sessions" <> query(opts)
    )
    |> handle_response()
  end

  defp livestreams_path(account_id, app_id), do: base(account_id, app_id) <> "/livestreams"

  defp meetings_base(account_id, app_id, meeting_id),
    do: base(account_id, app_id) <> "/meetings/#{meeting_id}"

  defp base(account_id, app_id), do: "/accounts/#{account_id}/realtime/kit/#{app_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
