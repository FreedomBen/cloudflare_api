defmodule CloudflareApi.IpAddressManagementAddressMaps do
  @moduledoc ~S"""
  Address Map helpers under `/accounts/:account_id/addressing/address_maps`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  @doc ~S"""
  Create ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Get ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.get(client, "account_id", "address_map_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, address_map_id) do
    request(client, :get, map_path(account_id, address_map_id))
  end

  @doc ~S"""
  Update ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.update(client, "account_id", "address_map_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, address_map_id, params) when is_map(params) do
    request(client, :patch, map_path(account_id, address_map_id), params)
  end

  @doc ~S"""
  Delete ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.delete(client, "account_id", "address_map_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, address_map_id) do
    request(client, :delete, map_path(account_id, address_map_id), %{})
  end

  @doc ~S"""
  Add account membership for ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.add_account_membership(client, "account_id", "address_map_id", "member_account_id")
      {:ok, %{"id" => "example"}}

  """

  def add_account_membership(client, account_id, address_map_id, member_account_id) do
    request(
      client,
      :put,
      map_path(account_id, address_map_id) <> "/accounts/#{member_account_id}",
      %{}
    )
  end

  @doc ~S"""
  Remove account membership for ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.remove_account_membership(client, "account_id", "address_map_id", "member_account_id")
      {:ok, %{"id" => "example"}}

  """

  def remove_account_membership(client, account_id, address_map_id, member_account_id) do
    request(
      client,
      :delete,
      map_path(account_id, address_map_id) <> "/accounts/#{member_account_id}",
      %{}
    )
  end

  @doc ~S"""
  Add ip for ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.add_ip(client, "account_id", "address_map_id", "ip_address")
      {:ok, %{"id" => "example"}}

  """

  def add_ip(client, account_id, address_map_id, ip_address) do
    request(
      client,
      :put,
      map_path(account_id, address_map_id) <> "/ips/#{ip_address}",
      %{}
    )
  end

  @doc ~S"""
  Remove ip for ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.remove_ip(client, "account_id", "address_map_id", "ip_address")
      {:ok, %{"id" => "example"}}

  """

  def remove_ip(client, account_id, address_map_id, ip_address) do
    request(
      client,
      :delete,
      map_path(account_id, address_map_id) <> "/ips/#{ip_address}",
      %{}
    )
  end

  @doc ~S"""
  Add zone membership for ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.add_zone_membership(client, "account_id", "address_map_id", "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def add_zone_membership(client, account_id, address_map_id, zone_id) do
    request(
      client,
      :put,
      map_path(account_id, address_map_id) <> "/zones/#{zone_id}",
      %{}
    )
  end

  @doc ~S"""
  Remove zone membership for ip address management address maps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementAddressMaps.remove_zone_membership(client, "account_id", "address_map_id", "zone_id")
      {:ok, %{"id" => "example"}}

  """

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
