defmodule CloudflareApi.ZeroTrustGatewayProxyEndpoints do
  @moduledoc ~S"""
  Manage Zero Trust Gateway proxy endpoints (`/accounts/:account_id/gateway/proxy_endpoints`).
  """

  @doc """
  List proxy endpoints (`GET /accounts/:account_id/gateway/proxy_endpoints`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc """
  Create a proxy endpoint (`POST /accounts/:account_id/gateway/proxy_endpoints`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Delete a proxy endpoint (`DELETE .../proxy_endpoints/:proxy_endpoint_id`).
  """
  def delete(client, account_id, endpoint_id) do
    c(client)
    |> Tesla.delete(endpoint_path(account_id, endpoint_id), body: %{})
    |> handle_response()
  end

  @doc """
  Fetch endpoint details (`GET .../proxy_endpoints/:proxy_endpoint_id`).
  """
  def get(client, account_id, endpoint_id) do
    c(client)
    |> Tesla.get(endpoint_path(account_id, endpoint_id))
    |> handle_response()
  end

  @doc """
  Update a proxy endpoint (`PATCH .../proxy_endpoints/:proxy_endpoint_id`).
  """
  def update(client, account_id, endpoint_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(endpoint_path(account_id, endpoint_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/proxy_endpoints"

  defp endpoint_path(account_id, endpoint_id),
    do: base_path(account_id) <> "/#{encode(endpoint_id)}"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
