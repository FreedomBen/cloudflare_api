defmodule CloudflareApi.DnsFirewall do
  @moduledoc ~S"""
  Manage DNS Firewall clusters under `/accounts/:account_id/dns_firewall`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List DNS firewall clusters (`GET /accounts/:account_id/dns_firewall`).
  """
  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create a cluster (`POST /accounts/:account_id/dns_firewall`).
  """
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Fetch cluster details (`GET /accounts/:account_id/dns_firewall/:id`).
  """
  def get(client, account_id, cluster_id) do
    request(client, :get, cluster_path(account_id, cluster_id))
  end

  @doc ~S"""
  Update a cluster (`PATCH /accounts/:account_id/dns_firewall/:id`).
  """
  def update(client, account_id, cluster_id, params) when is_map(params) do
    request(client, :patch, cluster_path(account_id, cluster_id), params)
  end

  @doc ~S"""
  Delete a cluster (`DELETE /accounts/:account_id/dns_firewall/:id`).
  """
  def delete(client, account_id, cluster_id) do
    request(client, :delete, cluster_path(account_id, cluster_id), %{})
  end

  @doc ~S"""
  Show reverse DNS settings (`GET /accounts/:account_id/dns_firewall/:id/reverse_dns`).
  """
  def reverse_dns(client, account_id, cluster_id) do
    request(client, :get, cluster_path(account_id, cluster_id) <> "/reverse_dns")
  end

  @doc ~S"""
  Update reverse DNS (`PATCH /accounts/:account_id/dns_firewall/:id/reverse_dns`).
  """
  def update_reverse_dns(client, account_id, cluster_id, params) when is_map(params) do
    request(client, :patch, cluster_path(account_id, cluster_id) <> "/reverse_dns", params)
  end

  defp base(account_id), do: "/accounts/#{account_id}/dns_firewall"
  defp cluster_path(account_id, cluster_id), do: base(account_id) <> "/#{cluster_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
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
