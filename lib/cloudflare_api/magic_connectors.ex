defmodule CloudflareApi.MagicConnectors do
  @moduledoc ~S"""
  Manage Magic WAN connectors and telemetry endpoints (`/accounts/:account_id/magic/connectors`).
  """

  @doc ~S"""
  List magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.get(client, "account_id", "connector_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, connector_id) do
    request(client, :get, connector_path(account_id, connector_id))
  end

  @doc ~S"""
  Update magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.update(client, "account_id", "connector_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, connector_id, params) when is_map(params) do
    request(client, :put, connector_path(account_id, connector_id), params)
  end

  @doc ~S"""
  Patch magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.patch(client, "account_id", "connector_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, connector_id, params) when is_map(params) do
    request(client, :patch, connector_path(account_id, connector_id), params)
  end

  @doc ~S"""
  Delete magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.delete(client, "account_id", "connector_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, connector_id) do
    request(client, :delete, connector_path(account_id, connector_id))
  end

  @doc ~S"""
  List events for magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.list_events(client, "account_id", "connector_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_events(client, account_id, connector_id, opts \\ []) do
    request(
      client,
      :get,
      connector_path(account_id, connector_id) <> "/telemetry/events" <> query(opts)
    )
  end

  @doc ~S"""
  Latest event for magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.latest_event(client, "account_id", "connector_id")
      {:ok, %{"id" => "example"}}

  """

  def latest_event(client, account_id, connector_id) do
    request(client, :get, connector_path(account_id, connector_id) <> "/telemetry/events/latest")
  end

  @doc ~S"""
  Get event for magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.get_event(client, "account_id", "connector_id", "event_t", "event_n")
      {:ok, %{"id" => "example"}}

  """

  def get_event(client, account_id, connector_id, event_t, event_n) do
    request(
      client,
      :get,
      connector_path(account_id, connector_id) <> "/telemetry/events/#{event_t}.#{event_n}"
    )
  end

  @doc ~S"""
  List snapshots for magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.list_snapshots(client, "account_id", "connector_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_snapshots(client, account_id, connector_id, opts \\ []) do
    request(
      client,
      :get,
      connector_path(account_id, connector_id) <> "/telemetry/snapshots" <> query(opts)
    )
  end

  @doc ~S"""
  Latest snapshot for magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.latest_snapshot(client, "account_id", "connector_id")
      {:ok, %{"id" => "example"}}

  """

  def latest_snapshot(client, account_id, connector_id) do
    request(
      client,
      :get,
      connector_path(account_id, connector_id) <> "/telemetry/snapshots/latest"
    )
  end

  @doc ~S"""
  Get snapshot for magic connectors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicConnectors.get_snapshot(client, "account_id", "connector_id", "snapshot_t")
      {:ok, %{"id" => "example"}}

  """

  def get_snapshot(client, account_id, connector_id, snapshot_t) do
    request(
      client,
      :get,
      connector_path(account_id, connector_id) <> "/telemetry/snapshots/#{snapshot_t}"
    )
  end

  defp base(account_id), do: "/accounts/#{account_id}/magic/connectors"
  defp connector_path(account_id, connector_id), do: base(account_id) <> "/#{connector_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
      end

    handle_response(result)
  end

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
