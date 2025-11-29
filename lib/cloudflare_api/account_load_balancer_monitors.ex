defmodule CloudflareApi.AccountLoadBalancerMonitors do
  @moduledoc ~S"""
  Manage load balancer monitors and previews at the account level.
  """

  @doc ~S"""
  List account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.get(client, "account_id", "monitor_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, monitor_id) do
    c(client)
    |> Tesla.get(monitor_path(account_id, monitor_id))
    |> handle_response()
  end

  @doc ~S"""
  Update account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.update(client, "account_id", "monitor_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, monitor_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(monitor_path(account_id, monitor_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Patch account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.patch(client, "account_id", "monitor_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, monitor_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(monitor_path(account_id, monitor_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.delete(client, "account_id", "monitor_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, monitor_id) do
    c(client)
    |> Tesla.delete(monitor_path(account_id, monitor_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Preview account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.preview(client, "account_id", "monitor_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def preview(client, account_id, monitor_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(monitor_path(account_id, monitor_id) <> "/preview", params)
    |> handle_response()
  end

  @doc ~S"""
  Preview result for account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.preview_result(client, "account_id", "preview_id")
      {:ok, %{"id" => "example"}}

  """

  def preview_result(client, account_id, preview_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/load_balancers/preview/#{preview_id}")
    |> handle_response()
  end

  @doc ~S"""
  List references for account load balancer monitors.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountLoadBalancerMonitors.list_references(client, "account_id", "monitor_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_references(client, account_id, monitor_id) do
    c(client)
    |> Tesla.get(monitor_path(account_id, monitor_id) <> "/references")
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/load_balancers/monitors"
  defp monitor_path(account_id, monitor_id), do: base_path(account_id) <> "/#{monitor_id}"

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
