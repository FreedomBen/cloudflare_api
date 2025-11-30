defmodule CloudflareApi.MagicGreTunnels do
  @moduledoc ~S"""
  Manage Magic GRE tunnels (`/accounts/:account_id/magic/gre_tunnels`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List magic gre tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicGreTunnels.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create magic gre tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicGreTunnels.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Update many for magic gre tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicGreTunnels.update_many(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_many(client, account_id, params) when is_map(params) do
    request(client, :put, base(account_id), params)
  end

  @doc ~S"""
  Get magic gre tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicGreTunnels.get(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, tunnel_id) do
    request(client, :get, tunnel_path(account_id, tunnel_id))
  end

  @doc ~S"""
  Update magic gre tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicGreTunnels.update(client, "account_id", "tunnel_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, tunnel_id, params) when is_map(params) do
    request(client, :put, tunnel_path(account_id, tunnel_id), params)
  end

  @doc ~S"""
  Delete magic gre tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicGreTunnels.delete(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, tunnel_id) do
    request(client, :delete, tunnel_path(account_id, tunnel_id))
  end

  defp base(account_id), do: "/accounts/#{account_id}/magic/gre_tunnels"
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
