defmodule CloudflareApi.AccountLoadBalancerPools do
  @moduledoc ~S"""
  Manage load balancer pools for an account, including health and previews.
  """

  @doc ~S"""
  List account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Patch many for account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.patch_many(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_many(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.get(client, "account_id", "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, pool_id) do
    c(client)
    |> Tesla.get(pool_path(account_id, pool_id))
    |> handle_response()
  end

  @doc ~S"""
  Update account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.update(client, "account_id", "pool_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, pool_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(pool_path(account_id, pool_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Patch account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.patch(client, "account_id", "pool_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, pool_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(pool_path(account_id, pool_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.delete(client, "account_id", "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, pool_id) do
    c(client)
    |> Tesla.delete(pool_path(account_id, pool_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Health account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.health(client, "account_id", "pool_id")
      {:ok, %{"id" => "example"}}

  """

  def health(client, account_id, pool_id) do
    c(client)
    |> Tesla.get(pool_path(account_id, pool_id) <> "/health")
    |> handle_response()
  end

  @doc ~S"""
  Preview account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.preview(client, "account_id", "pool_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def preview(client, account_id, pool_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(pool_path(account_id, pool_id) <> "/preview", params)
    |> handle_response()
  end

  @doc ~S"""
  List references for account load balancer pools.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerPools.list_references(client, "account_id", "pool_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_references(client, account_id, pool_id) do
    c(client)
    |> Tesla.get(pool_path(account_id, pool_id) <> "/references")
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/load_balancers/pools"
  defp pool_path(account_id, pool_id), do: base_path(account_id) <> "/#{pool_id}"

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
