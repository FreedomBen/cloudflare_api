defmodule CloudflareApi.MagicIpsecTunnels do
  @moduledoc ~S"""
  Manage Magic IPsec tunnels (`/accounts/:account_id/magic/ipsec_tunnels`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Update many for magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.update_many(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_many(client, account_id, params) when is_map(params) do
    request(client, :put, base(account_id), params)
  end

  @doc ~S"""
  Get magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.get(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, tunnel_id) do
    request(client, :get, tunnel_path(account_id, tunnel_id))
  end

  @doc ~S"""
  Update magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.update(client, "account_id", "tunnel_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, tunnel_id, params) when is_map(params) do
    request(client, :put, tunnel_path(account_id, tunnel_id), params)
  end

  @doc ~S"""
  Delete magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.delete(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, tunnel_id) do
    request(client, :delete, tunnel_path(account_id, tunnel_id))
  end

  @doc ~S"""
  Generate psk for magic ipsec tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicIpsecTunnels.generate_psk(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def generate_psk(client, account_id, tunnel_id) do
    request(client, :post, tunnel_path(account_id, tunnel_id) <> "/psk_generate", %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/magic/ipsec_tunnels"
  defp tunnel_path(account_id, tunnel_id), do: base(account_id) <> "/#{tunnel_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
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
