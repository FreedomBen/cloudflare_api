defmodule CloudflareApi.MagicNetworkMonitoringRules do
  @moduledoc ~S"""
  Manage Magic Network Monitoring rules (`/accounts/:account_id/mnm/rules`).
  """

  @doc ~S"""
  List magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Replace magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.replace(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def replace(client, account_id, params) when is_map(params) do
    request(client, :put, base(account_id), params)
  end

  @doc ~S"""
  Get magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.get(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, rule_id) do
    request(client, :get, rule_path(account_id, rule_id))
  end

  @doc ~S"""
  Update magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.update(client, "account_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, rule_id, params) when is_map(params) do
    request(client, :patch, rule_path(account_id, rule_id), params)
  end

  @doc ~S"""
  Update advertisement for magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.update_advertisement(client, "account_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_advertisement(client, account_id, rule_id, params) when is_map(params) do
    request(client, :patch, rule_path(account_id, rule_id) <> "/advertisement", params)
  end

  @doc ~S"""
  Delete magic network monitoring rules.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringRules.delete(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, rule_id) do
    request(client, :delete, rule_path(account_id, rule_id))
  end

  defp base(account_id), do: "/accounts/#{account_id}/mnm/rules"
  defp rule_path(account_id, rule_id), do: base(account_id) <> "/#{rule_id}"

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
