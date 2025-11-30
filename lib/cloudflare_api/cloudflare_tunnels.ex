defmodule CloudflareApi.CloudflareTunnels do
  @moduledoc ~S"""
  Manage Cloudflare Tunnels and Warp Connector tunnels.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List cfd for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.list_cfd(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_cfd(client, account_id, opts \\ []) do
    request(:get, cfd_base(account_id), client, query: opts)
  end

  @doc ~S"""
  List all for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.list_all(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_all(client, account_id, opts \\ []) do
    request(:get, "/accounts/#{account_id}/tunnels", client, query: opts)
  end

  @doc ~S"""
  List warp for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.list_warp(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_warp(client, account_id, opts \\ []) do
    request(:get, "/accounts/#{account_id}/warp_connector", client, query: opts)
  end

  @doc ~S"""
  Create cfd for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.create_cfd(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_cfd(client, account_id, params) when is_map(params) do
    request(:post, cfd_base(account_id), client, body: params)
  end

  @doc ~S"""
  Create warp for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.create_warp(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_warp(client, account_id, params) when is_map(params) do
    request(:post, "/accounts/#{account_id}/warp_connector", client, body: params)
  end

  @doc ~S"""
  Get cfd for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.get_cfd(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def get_cfd(client, account_id, tunnel_id) do
    request(:get, cfd_path(account_id, tunnel_id), client)
  end

  @doc ~S"""
  Get warp for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.get_warp(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def get_warp(client, account_id, tunnel_id) do
    request(:get, "/accounts/#{account_id}/warp_connector/#{tunnel_id}", client)
  end

  @doc ~S"""
  Update cfd for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.update_cfd(client, "account_id", "tunnel_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_cfd(client, account_id, tunnel_id, params) when is_map(params) do
    request(:patch, cfd_path(account_id, tunnel_id), client, body: params)
  end

  @doc ~S"""
  Update warp for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.update_warp(client, "account_id", "tunnel_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_warp(client, account_id, tunnel_id, params) when is_map(params) do
    request(:patch, "/accounts/#{account_id}/warp_connector/#{tunnel_id}", client, body: params)
  end

  @doc ~S"""
  Delete cfd for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.delete_cfd(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_cfd(client, account_id, tunnel_id) do
    request(:delete, cfd_path(account_id, tunnel_id), client, body: %{})
  end

  @doc ~S"""
  Delete warp for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.delete_warp(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_warp(client, account_id, tunnel_id) do
    request(:delete, "/accounts/#{account_id}/warp_connector/#{tunnel_id}", client, body: %{})
  end

  @doc ~S"""
  Token cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.token(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def token(client, account_id, tunnel_id) do
    request(:get, cfd_path(account_id, tunnel_id) <> "/token", client)
  end

  @doc ~S"""
  Warp token for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.warp_token(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def warp_token(client, account_id, tunnel_id) do
    request(:get, "/accounts/#{account_id}/warp_connector/#{tunnel_id}/token", client)
  end

  @doc ~S"""
  Connectors cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.connectors(client, "account_id", "tunnel_id")
      {:ok, %{"id" => "example"}}

  """

  def connectors(client, account_id, tunnel_id) do
    request(:get, cfd_path(account_id, tunnel_id) <> "/connections", client)
  end

  @doc ~S"""
  Cleanup connections for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.cleanup_connections(client, "account_id", "tunnel_id", [])
      {:ok, %{"id" => "example"}}

  """

  def cleanup_connections(client, account_id, tunnel_id, opts \\ []) do
    request(
      :delete,
      cfd_path(account_id, tunnel_id) <> "/connections",
      client,
      body: %{},
      query: opts
    )
  end

  @doc ~S"""
  Connector cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.connector(client, "account_id", "tunnel_id", "connector_id")
      {:ok, %{"id" => "example"}}

  """

  def connector(client, account_id, tunnel_id, connector_id) do
    request(:get, cfd_path(account_id, tunnel_id) <> "/connectors/#{connector_id}", client)
  end

  @doc ~S"""
  Management token for cloudflare tunnels.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareTunnels.management_token(client, "account_id", "tunnel_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def management_token(client, account_id, tunnel_id, params) when is_map(params) do
    request(:post, cfd_path(account_id, tunnel_id) <> "/management", client, body: params)
  end

  defp cfd_base(account_id), do: "/accounts/#{account_id}/cfd_tunnel"
  defp cfd_path(account_id, tunnel_id), do: cfd_base(account_id) <> "/#{tunnel_id}"

  defp request(method, url, client, opts \\ []) do
    client = c(client)
    query = Keyword.get(opts, :query, [])
    body = Keyword.get(opts, :body, nil)

    case method do
      :get -> Tesla.get(client, url_with_query(url, query))
      :delete -> Tesla.delete(client, url_with_query(url, query), body: body)
      :post -> Tesla.post(client, url_with_query(url, query), body)
      :patch -> Tesla.patch(client, url_with_query(url, query), body)
    end
    |> handle_response()
  end

  defp url_with_query(url, []), do: url
  defp url_with_query(url, query), do: url <> "?" <> CloudflareApi.uri_encode_opts(query)

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
