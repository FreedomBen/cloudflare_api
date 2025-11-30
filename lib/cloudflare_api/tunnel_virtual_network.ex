defmodule CloudflareApi.TunnelVirtualNetwork do
  @moduledoc ~S"""
  Manage tunnel virtual networks under `/accounts/:account_id/teamnet/virtual_networks`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List tunnel virtual network.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TunnelVirtualNetwork.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create tunnel virtual network.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TunnelVirtualNetwork.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get tunnel virtual network.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TunnelVirtualNetwork.get(client, "account_id", "vnet_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, vnet_id) do
    c(client)
    |> Tesla.get(vnet_path(account_id, vnet_id))
    |> handle_response()
  end

  @doc ~S"""
  Update tunnel virtual network.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TunnelVirtualNetwork.update(client, "account_id", "vnet_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, vnet_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(vnet_path(account_id, vnet_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete tunnel virtual network.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.TunnelVirtualNetwork.delete(client, "account_id", "vnet_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, vnet_id) do
    c(client)
    |> Tesla.delete(vnet_path(account_id, vnet_id), body: %{})
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/teamnet/virtual_networks"

  defp vnet_path(account_id, vnet_id) do
    base(account_id) <> "/#{encode(vnet_id)}"
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
