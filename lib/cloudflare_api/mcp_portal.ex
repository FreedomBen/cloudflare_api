defmodule CloudflareApi.McpPortal do
  @moduledoc ~S"""
  Thin wrapper around the Access AI Controls MCP portal endpoints
  (`/accounts/:account_id/access/ai-controls/mcp/portals`).
  """

  @doc ~S"""
  List all MCP portals for an account.

  Wraps `GET /accounts/:account_id/access/ai-controls/mcp/portals`. Optional
  `opts` values are encoded as query parameters (for pagination, filtering, etc.).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new MCP portal.

  Wraps `POST /accounts/:account_id/access/ai-controls/mcp/portals`.
  Pass the JSON body as a map (for example, `%{"name" => "portal"}`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch details for a single MCP portal.

  Wraps `GET /accounts/:account_id/access/ai-controls/mcp/portals/:id`.
  """
  def get(client, account_id, portal_id) do
    c(client)
    |> Tesla.get(portal_path(account_id, portal_id))
    |> handle_response()
  end

  @doc ~S"""
  Update an existing MCP portal in place.

  Wraps `PUT /accounts/:account_id/access/ai-controls/mcp/portals/:id` and
  sends the provided params as the JSON body.
  """
  def update(client, account_id, portal_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(portal_path(account_id, portal_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an MCP portal.

  Wraps `DELETE /accounts/:account_id/access/ai-controls/mcp/portals/:id`.
  """
  def delete(client, account_id, portal_id) do
    c(client)
    |> Tesla.delete(portal_path(account_id, portal_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id),
    do: "/accounts/#{account_id}/access/ai-controls/mcp/portals"

  defp portal_path(account_id, portal_id), do: base_path(account_id) <> "/#{portal_id}"

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
