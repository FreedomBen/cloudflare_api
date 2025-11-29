defmodule CloudflareApi.IpAddressManagementDynamicAdvertisement do
  @moduledoc ~S"""
  Dynamic advertisement status helpers for prefixes under
  `/accounts/:account_id/addressing/prefixes/:prefix_id/bgp/status`.
  """

  @doc ~S"""
  Get status for ip address management dynamic advertisement.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementDynamicAdvertisement.get_status(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_status(client, account_id, prefix_id) do
    request(client, :get, status_path(account_id, prefix_id))
  end

  @doc ~S"""
  Update status for ip address management dynamic advertisement.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementDynamicAdvertisement.update_status(client, "account_id", "prefix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_status(client, account_id, prefix_id, params) when is_map(params) do
    request(client, :patch, status_path(account_id, prefix_id), params)
  end

  defp status_path(account_id, prefix_id),
    do: "/accounts/#{account_id}/addressing/prefixes/#{prefix_id}/bgp/status"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)
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
