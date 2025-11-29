defmodule CloudflareApi.IpAddressManagementAddressMaps do
  @moduledoc ~S"""
  Address Map helpers under `/accounts/:account_id/addressing/address_maps`.
  """

  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  def get(client, account_id, address_map_id) do
    request(client, :get, map_path(account_id, address_map_id))
  end

  def update(client, account_id, address_map_id, params) when is_map(params) do
    request(client, :patch, map_path(account_id, address_map_id), params)
  end

  def delete(client, account_id, address_map_id) do
    request(client, :delete, map_path(account_id, address_map_id), %{})
  end

  def add_account_membership(client, account_id, address_map_id, member_account_id) do
    request(
      client,
      :put,
      map_path(account_id, address_map_id) <> "/accounts/#{member_account_id}",
      %{}
    )
  end

  def remove_account_membership(client, account_id, address_map_id, member_account_id) do
    request(
      client,
      :delete,
      map_path(account_id, address_map_id) <> "/accounts/#{member_account_id}",
      %{}
    )
  end

  def add_ip(client, account_id, address_map_id, ip_address) do
    request(
      client,
      :put,
      map_path(account_id, address_map_id) <> "/ips/#{ip_address}",
      %{}
    )
  end

  def remove_ip(client, account_id, address_map_id, ip_address) do
    request(
      client,
      :delete,
      map_path(account_id, address_map_id) <> "/ips/#{ip_address}",
      %{}
    )
  end

  def add_zone_membership(client, account_id, address_map_id, zone_id) do
    request(
      client,
      :put,
      map_path(account_id, address_map_id) <> "/zones/#{zone_id}",
      %{}
    )
  end

  def remove_zone_membership(client, account_id, address_map_id, zone_id) do
    request(
      client,
      :delete,
      map_path(account_id, address_map_id) <> "/zones/#{zone_id}",
      %{}
    )
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/addressing/address_maps"
  defp map_path(account_id, address_map_id), do: base_path(account_id) <> "/#{address_map_id}"

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

        {:put, %{} = params} ->
          Tesla.put(client, url, params)

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
