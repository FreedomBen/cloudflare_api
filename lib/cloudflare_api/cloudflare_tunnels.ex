defmodule CloudflareApi.CloudflareTunnels do
  @moduledoc ~S"""
  Manage Cloudflare and Warp Connector tunnels plus related tokens/connectors.
  """

  def list_cfd(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(cfd_base(account_id) <> query_suffix(opts))
    |> handle_response()
  end

  def list_all(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/tunnels" <> query_suffix(opts))
    |> handle_response()
  end

  def list_warp(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/warp_connector" <> query_suffix(opts))
    |> handle_response()
  end

  def create_cfd(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(cfd_base(account_id), params)
    |> handle_response()
  end

  def create_warp(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/warp_connector", params)
    |> handle_response()
  end

  def get_cfd(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.get(cfd_path(account_id, tunnel_id))
    |> handle_response()
  end

  def get_warp(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/warp_connector/#{tunnel_id}")
    |> handle_response()
  end

  def update_cfd(client, account_id, tunnel_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(cfd_path(account_id, tunnel_id), params)
    |> handle_response()
  end

  def update_warp(client, account_id, tunnel_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch("/accounts/#{account_id}/warp_connector/#{tunnel_id}", params)
    |> handle_response()
  end

  def delete_cfd(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.delete(cfd_path(account_id, tunnel_id), body: %{})
    |> handle_response()
  end

  def delete_warp(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.delete("/accounts/#{account_id}/warp_connector/#{tunnel_id}", body: %{})
    |> handle_response()
  end

  def token(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.get(cfd_path(account_id, tunnel_id) <> "/token")
    |> handle_response()
  end

  def warp_token(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/warp_connector/#{tunnel_id}/token")
    |> handle_response()
  end

  def connectors(client, account_id, tunnel_id) do
    c(client)
    |> Tesla.get(cfd_path(account_id, tunnel_id) <> "/connections")
    |> handle_response()
  end

  def cleanup_connections(client, account_id, tunnel_id, opts \\ []) do
    c(client)
    |> Tesla.delete(
      cfd_path(account_id, tunnel_id) <> "/connections" <> query_suffix(opts),
      body: %{}
    )
    |> handle_response()
  end

  def connector(client, account_id, tunnel_id, connector_id) do
    c(client)
    |> Tesla.get(cfd_path(account_id, tunnel_id) <> "/connectors/#{connector_id}")
    |> handle_response()
  end

  def management_token(client, account_id, tunnel_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(cfd_path(account_id, tunnel_id) <> "/management", params)
    |> handle_response()
  end

  defp cfd_base(account_id), do: "/accounts/#{account_id}/cfd_tunnel"
  defp cfd_path(account_id, tunnel_id), do: cfd_base(account_id) <> "/#{tunnel_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
