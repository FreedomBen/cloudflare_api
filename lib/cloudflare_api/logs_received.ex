defmodule CloudflareApi.LogsReceived do
  @moduledoc ~S"""
  Retrieve zone-level Logpull data, retention flags, and RayID lookups.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Get retention flag for logs received.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogsReceived.get_retention_flag(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_retention_flag(client, zone_id) do
    request(client, :get, retention_path(zone_id))
  end

  @doc ~S"""
  Update retention flag for logs received.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogsReceived.update_retention_flag(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_retention_flag(client, zone_id, params) when is_map(params) do
    request(client, :post, retention_path(zone_id), params)
  end

  @doc ~S"""
  List logs received.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogsReceived.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    request(client, :get, logs_path(zone_id) <> query(opts))
  end

  @doc ~S"""
  List fields for logs received.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogsReceived.list_fields(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_fields(client, zone_id) do
    request(client, :get, logs_path(zone_id) <> "/fields")
  end

  @doc ~S"""
  Get ray ids for logs received.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogsReceived.get_ray_ids(client, "zone_id", "ray_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_ray_ids(client, zone_id, ray_id, opts \\ []) do
    request(client, :get, "/zones/#{zone_id}/logs/rayids/#{ray_id}" <> query(opts))
  end

  defp retention_path(zone_id), do: "/zones/#{zone_id}/logs/control/retention/flag"
  defp logs_path(zone_id), do: "/zones/#{zone_id}/logs/received"
  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
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
