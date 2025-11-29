defmodule CloudflareApi.LoadBalancerPools do
  @moduledoc ~S"""
  Manage user-level load balancer pools (`/user/load_balancers/pools`).
  """

  @doc ~S"""
  List load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    request(client, :get, pools_path() <> query(opts))
  end

  @doc ~S"""
  Patch bulk for load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.patch_bulk(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_bulk(client, params) when is_map(params) do
    request(client, :patch, pools_path(), params)
  end

  @doc ~S"""
  Create load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.create(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, params) when is_map(params) do
    request(client, :post, pools_path(), params)
  end

  @doc ~S"""
  Get load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.get(client, "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, pool_id) do
    request(client, :get, pool_path(pool_id))
  end

  @doc ~S"""
  Update load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.update(client, "pool_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, pool_id, params) when is_map(params) do
    request(client, :put, pool_path(pool_id), params)
  end

  @doc ~S"""
  Patch load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.patch(client, "pool_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, pool_id, params) when is_map(params) do
    request(client, :patch, pool_path(pool_id), params)
  end

  @doc ~S"""
  Delete load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.delete(client, "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, pool_id) do
    request(client, :delete, pool_path(pool_id), %{})
  end

  @doc ~S"""
  Health load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.health(client, "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def health(client, pool_id) do
    request(client, :get, pool_path(pool_id) <> "/health")
  end

  @doc ~S"""
  Preview load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.preview(client, "pool_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def preview(client, pool_id, params) when is_map(params) do
    request(client, :post, pool_path(pool_id) <> "/preview", params)
  end

  @doc ~S"""
  References load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LoadBalancerPools.references(client, "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def references(client, pool_id) do
    request(client, :get, pool_path(pool_id) <> "/references")
  end

  defp pools_path, do: "/user/load_balancers/pools"
  defp pool_path(pool_id), do: pools_path() <> "/#{pool_id}"
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
