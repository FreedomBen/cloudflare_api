defmodule CloudflareApi.LoadBalancerMonitors do
  @moduledoc ~S"""
  Manage user-level load balancer monitors (`/user/load_balancers/monitors`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.list(client)
      {:ok, [%{"id" => "example"}]}

  """

  def list(client) do
    request(client, :get, monitors_path())
  end

  @doc ~S"""
  Create load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.create(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, params) when is_map(params) do
    request(client, :post, monitors_path(), params)
  end

  @doc ~S"""
  Get load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.get(client, "monitor_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, monitor_id) do
    request(client, :get, monitor_path(monitor_id))
  end

  @doc ~S"""
  Update load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.update(client, "monitor_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, monitor_id, params) when is_map(params) do
    request(client, :put, monitor_path(monitor_id), params)
  end

  @doc ~S"""
  Patch load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.patch(client, "monitor_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, monitor_id, params) when is_map(params) do
    request(client, :patch, monitor_path(monitor_id), params)
  end

  @doc ~S"""
  Delete load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.delete(client, "monitor_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, monitor_id) do
    request(client, :delete, monitor_path(monitor_id), %{})
  end

  @doc ~S"""
  Preview load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.preview(client, "monitor_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def preview(client, monitor_id, params) when is_map(params) do
    request(client, :post, monitor_path(monitor_id) <> "/preview", params)
  end

  @doc ~S"""
  References load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.references(client, "monitor_id")
      {:ok, %{"id" => "example"}}

  """

  def references(client, monitor_id) do
    request(client, :get, monitor_path(monitor_id) <> "/references")
  end

  @doc ~S"""
  Preview result for load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerMonitors.preview_result(client, "preview_id")
      {:ok, %{"id" => "example"}}

  """

  def preview_result(client, preview_id) do
    request(client, :get, "/user/load_balancers/preview/#{preview_id}")
  end

  defp monitors_path, do: "/user/load_balancers/monitors"
  defp monitor_path(monitor_id), do: monitors_path() <> "/#{monitor_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
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
