defmodule CloudflareApi.IpAddressManagementPrefixDelegation do
  @moduledoc ~S"""
  Prefix delegation helpers for `/accounts/:account_id/addressing/prefixes/:prefix_id/delegations`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List ip address management prefix delegation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixDelegation.list(client, "account_id", "prefix_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, prefix_id) do
    request(client, :get, base_path(account_id, prefix_id))
  end

  @doc ~S"""
  Create ip address management prefix delegation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixDelegation.create(client, "account_id", "prefix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, prefix_id, params) when is_map(params) do
    request(client, :post, base_path(account_id, prefix_id), params)
  end

  @doc ~S"""
  Delete ip address management prefix delegation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixDelegation.delete(client, "account_id", "prefix_id", "delegation_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, prefix_id, delegation_id) do
    request(client, :delete, base_path(account_id, prefix_id) <> "/#{delegation_id}", %{})
  end

  defp base_path(account_id, prefix_id),
    do: "/accounts/#{account_id}/addressing/prefixes/#{prefix_id}/delegations"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)
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
