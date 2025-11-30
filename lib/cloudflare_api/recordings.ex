defmodule CloudflareApi.Recordings do
  @moduledoc ~S"""
  Manage Realtime Kit recordings (`/accounts/:account_id/realtime/kit/:app_id/recordings`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List recordings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Recordings.list(client, "account_id", "app_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, app_id, opts \\ []) do
    request(client, :get, with_query(base_path(account_id, app_id), opts))
  end

  @doc ~S"""
  Start recordings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Recordings.start(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def start(client, account_id, app_id, params) when is_map(params) do
    request(client, :post, base_path(account_id, app_id), params)
  end

  @doc ~S"""
  Get recordings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Recordings.get(client, "account_id", "app_id", "recording_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id, recording_id, opts \\ []) do
    request(client, :get, with_query(recording_path(account_id, app_id, recording_id), opts))
  end

  @doc ~S"""
  Update recordings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Recordings.update(client, "account_id", "app_id", "recording_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, app_id, recording_id, params) when is_map(params) do
    request(client, :put, recording_path(account_id, app_id, recording_id), params)
  end

  @doc ~S"""
  Active recording for recordings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Recordings.active_recording(client, "account_id", "app_id", "meeting_id", [])
      {:ok, %{"id" => "example"}}

  """

  def active_recording(client, account_id, app_id, meeting_id, opts \\ []) do
    path = base_path(account_id, app_id) <> "/active-recording/" <> encode(meeting_id)
    request(client, :get, with_query(path, opts))
  end

  @doc ~S"""
  Start track for recordings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Recordings.start_track(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def start_track(client, account_id, app_id, params) when is_map(params) do
    request(client, :post, base_path(account_id, app_id) <> "/track", params)
  end

  defp base_path(account_id, app_id),
    do: "/accounts/#{account_id}/realtime/kit/#{app_id}/recordings"

  defp recording_path(account_id, app_id, recording_id),
    do: base_path(account_id, app_id) <> "/#{encode(recording_id)}"

  defp request(client_or_fun, method, url, body \\ nil) do
    client = c(client_or_fun)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
      end

    handle_response(result)
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
