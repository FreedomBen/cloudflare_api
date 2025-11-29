defmodule CloudflareApi.McpPortalServers do
  @moduledoc ~S"""
  Manage MCP servers for Access AI Controls portals
  (`/accounts/:account_id/access/ai-controls/mcp/servers`).
  """

  @doc ~S"""
  List MCP servers for an account via `GET /accounts/:account_id/access/ai-controls/mcp/servers`.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new MCP server (`POST /accounts/:account_id/access/ai-controls/mcp/servers`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a server's details (`GET /accounts/:account_id/access/ai-controls/mcp/servers/:id`).
  """
  def get(client, account_id, server_id) do
    c(client)
    |> Tesla.get(server_path(account_id, server_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a server definition (`PUT /accounts/:account_id/access/ai-controls/mcp/servers/:id`).
  """
  def update(client, account_id, server_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(server_path(account_id, server_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an MCP server (`DELETE /accounts/:account_id/access/ai-controls/mcp/servers/:id`).
  """
  def delete(client, account_id, server_id) do
    c(client)
    |> Tesla.delete(server_path(account_id, server_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Trigger a server sync to refresh capabilities.

  Wraps `POST /accounts/:account_id/access/ai-controls/mcp/servers/:id/sync`.
  """
  def sync(client, account_id, server_id) do
    c(client)
    |> Tesla.post(sync_path(account_id, server_id), %{})
    |> handle_response()
  end

  defp base_path(account_id),
    do: "/accounts/#{account_id}/access/ai-controls/mcp/servers"

  defp server_path(account_id, server_id), do: base_path(account_id) <> "/#{server_id}"

  defp sync_path(account_id, server_id), do: server_path(account_id, server_id) <> "/sync"

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
