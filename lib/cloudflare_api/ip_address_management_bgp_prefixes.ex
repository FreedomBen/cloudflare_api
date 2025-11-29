defmodule CloudflareApi.IpAddressManagementBgpPrefixes do
  @moduledoc ~S"""
  Manage BGP prefixes under
  `/accounts/:account_id/addressing/prefixes/:prefix_id/bgp/prefixes`.
  """

  def list(client, account_id, prefix_id) do
    request(client, :get, base_path(account_id, prefix_id))
  end

  def create(client, account_id, prefix_id, params) when is_map(params) do
    request(client, :post, base_path(account_id, prefix_id), params)
  end

  def get(client, account_id, prefix_id, bgp_prefix_id) do
    request(client, :get, prefix_path(account_id, prefix_id, bgp_prefix_id))
  end

  def update(client, account_id, prefix_id, bgp_prefix_id, params) when is_map(params) do
    request(client, :patch, prefix_path(account_id, prefix_id, bgp_prefix_id), params)
  end

  def delete(client, account_id, prefix_id, bgp_prefix_id) do
    request(client, :delete, prefix_path(account_id, prefix_id, bgp_prefix_id), %{})
  end

  defp base_path(account_id, prefix_id),
    do: "/accounts/#{account_id}/addressing/prefixes/#{prefix_id}/bgp/prefixes"

  defp prefix_path(account_id, prefix_id, bgp_prefix_id),
    do: base_path(account_id, prefix_id) <> "/#{bgp_prefix_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

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
