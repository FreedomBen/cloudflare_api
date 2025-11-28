defmodule CloudflareApi.AiGatewayLogs do
  @moduledoc ~S"""
  Helpers for working with AI Gateway logs under a specific gateway.

  All functions wrap the `/accounts/:account_id/ai-gateway/gateways/:gateway_id/logs`
  endpoints and return `{:ok, result}` / `{:error, errors}` tuples.
  """

  @doc ~S"""
  List logs for a gateway. Supports pagination/filters via `opts`.
  """
  def list(client, account_id, gateway_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, gateway_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete logs (`DELETE /logs`). Cloudflare treats this as a bulk delete.
  """
  def delete_all(client, account_id, gateway_id) do
    c(client)
    |> Tesla.delete(base_path(account_id, gateway_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch an individual log entry by ID.
  """
  def get(client, account_id, gateway_id, log_id) do
    c(client)
    |> Tesla.get(log_path(account_id, gateway_id, log_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a log entry via `PATCH`.
  """
  def update(client, account_id, gateway_id, log_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(log_path(account_id, gateway_id, log_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve the raw request data for a log (`GET /logs/:id/request`).
  """
  def get_request(client, account_id, gateway_id, log_id) do
    c(client)
    |> Tesla.get(log_path(account_id, gateway_id, log_id) <> "/request")
    |> handle_response()
  end

  @doc ~S"""
  Retrieve the raw response data for a log (`GET /logs/:id/response`).
  """
  def get_response(client, account_id, gateway_id, log_id) do
    c(client)
    |> Tesla.get(log_path(account_id, gateway_id, log_id) <> "/response")
    |> handle_response()
  end

  defp list_url(account_id, gateway_id, []), do: base_path(account_id, gateway_id)

  defp list_url(account_id, gateway_id, opts) do
    base_path(account_id, gateway_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, gateway_id) do
    "/accounts/#{account_id}/ai-gateway/gateways/#{gateway_id}/logs"
  end

  defp log_path(account_id, gateway_id, log_id) do
    base_path(account_id, gateway_id) <> "/#{log_id}"
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
