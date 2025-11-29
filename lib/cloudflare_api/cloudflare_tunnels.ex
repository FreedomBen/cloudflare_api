defmodule CloudflareApi.CloudflareTunnels do
  @moduledoc ~S"""
  Manage Cloudflare Tunnels and Warp Connector tunnels.
  """

  def list_cfd(client, account_id, opts \\ []) do
    request(:get, cfd_base(account_id), client, query: opts)
  end

  def list_all(client, account_id, opts \\ []) do
    request(:get, "/accounts/#{account_id}/tunnels", client, query: opts)
  end

  def list_warp(client, account_id, opts \\ []) do
    request(:get, "/accounts/#{account_id}/warp_connector", client, query: opts)
  end

  def create_cfd(client, account_id, params) when is_map(params) do
    request(:post, cfd_base(account_id), client, body: params)
  end

  def create_warp(client, account_id, params) when is_map(params) do
    request(:post, "/accounts/#{account_id}/warp_connector", client, body: params)
  end

  def get_cfd(client, account_id, tunnel_id) do
    request(:get, cfd_path(account_id, tunnel_id), client)
  end

  def get_warp(client, account_id, tunnel_id) do
    request(:get, "/accounts/#{account_id}/warp_connector/#{tunnel_id}", client)
  end

  def update_cfd(client, account_id, tunnel_id, params) when is_map(params) do
    request(:patch, cfd_path(account_id, tunnel_id), client, body: params)
  end

  def update_warp(client, account_id, tunnel_id, params) when is_map(params) do
    request(:patch, "/accounts/#{account_id}/warp_connector/#{tunnel_id}", client, body: params)
  end

  def delete_cfd(client, account_id, tunnel_id) do
    request(:delete, cfd_path(account_id, tunnel_id), client, body: %{})
  end

  def delete_warp(client, account_id, tunnel_id) do
    request(:delete, "/accounts/#{account_id}/warp_connector/#{tunnel_id}", client, body: %{})
  end

  def token(client, account_id, tunnel_id) do
    request(:get, cfd_path(account_id, tunnel_id) <> "/token", client)
  end

  def warp_token(client, account_id, tunnel_id) do
    request(:get, "/accounts/#{account_id}/warp_connector/#{tunnel_id}/token", client)
  end

  def connectors(client, account_id, tunnel_id) do
    request(:get, cfd_path(account_id, tunnel_id) <> "/connections", client)
  end

  def cleanup_connections(client, account_id, tunnel_id, opts \\ []) do
    request(
      :delete,
      cfd_path(account_id, tunnel_id) <> "/connections",
      client,
      body: %{},
      query: opts
    )
  end

  def connector(client, account_id, tunnel_id, connector_id) do
    request(:get, cfd_path(account_id, tunnel_id) <> "/connectors/#{connector_id}", client)
  end

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
