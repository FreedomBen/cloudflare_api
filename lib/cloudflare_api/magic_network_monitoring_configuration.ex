defmodule CloudflareApi.MagicNetworkMonitoringConfiguration do
  @moduledoc ~S"""
  Manage Magic Network Monitoring account configuration (`/accounts/:account_id/mnm/config`).
  """

  @doc ~S"""
  Get magic network monitoring configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringConfiguration.get(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Get full for magic network monitoring configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringConfiguration.get_full(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_full(client, account_id) do
    request(client, :get, base(account_id) <> "/full")
  end

  @doc ~S"""
  Create magic network monitoring configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringConfiguration.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Replace magic network monitoring configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringConfiguration.replace(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def replace(client, account_id, params) when is_map(params) do
    request(client, :put, base(account_id), params)
  end

  @doc ~S"""
  Update fields for magic network monitoring configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringConfiguration.update_fields(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_fields(client, account_id, params) when is_map(params) do
    request(client, :patch, base(account_id), params)
  end

  @doc ~S"""
  Delete magic network monitoring configuration.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicNetworkMonitoringConfiguration.delete(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id) do
    request(client, :delete, base(account_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/mnm/config"

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
