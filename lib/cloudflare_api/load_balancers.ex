defmodule CloudflareApi.LoadBalancers do
  @moduledoc ~S"""
  Manage zone-level load balancers (`/zones/:zone_id/load_balancers`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List load balancers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancers.list(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id) do
    request(client, :get, base(zone_id))
  end

  @doc ~S"""
  Create load balancers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancers.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id), params)
  end

  @doc ~S"""
  Get load balancers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancers.get(client, "zone_id", "load_balancer_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, load_balancer_id) do
    request(client, :get, lb_path(zone_id, load_balancer_id))
  end

  @doc ~S"""
  Update load balancers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancers.update(client, "zone_id", "load_balancer_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, load_balancer_id, params) when is_map(params) do
    request(client, :put, lb_path(zone_id, load_balancer_id), params)
  end

  @doc ~S"""
  Patch load balancers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancers.patch(client, "zone_id", "load_balancer_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, zone_id, load_balancer_id, params) when is_map(params) do
    request(client, :patch, lb_path(zone_id, load_balancer_id), params)
  end

  @doc ~S"""
  Delete load balancers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancers.delete(client, "zone_id", "load_balancer_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, load_balancer_id) do
    request(client, :delete, lb_path(zone_id, load_balancer_id), %{})
  end

  defp base(zone_id), do: "/zones/#{zone_id}/load_balancers"
  defp lb_path(zone_id, load_balancer_id), do: base(zone_id) <> "/#{load_balancer_id}"

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
