defmodule CloudflareApi.AiGatewayGateways do
  @moduledoc ~S"""
  Manage AI Gateway configurations for an account.

  Wraps `/accounts/:account_id/ai-gateway/gateways` endpoints, including helper
  functions for fetching provider URLs.
  """

  @doc ~S"""
  List gateways for an account. Supports pagination/filter opts.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a gateway (`POST /gateways`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a gateway by ID.
  """
  def get(client, account_id, gateway_id) do
    c(client)
    |> Tesla.get(gateway_path(account_id, gateway_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a gateway via `PUT`.
  """
  def update(client, account_id, gateway_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(gateway_path(account_id, gateway_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a gateway.
  """
  def delete(client, account_id, gateway_id) do
    c(client)
    |> Tesla.delete(gateway_path(account_id, gateway_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch the provider URL for a gateway (`GET /gateways/:id/url/:provider`).
  """
  def provider_url(client, account_id, gateway_id, provider) do
    c(client)
    |> Tesla.get("#{gateway_path(account_id, gateway_id)}/url/#{provider}")
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/ai-gateway/gateways"
  defp gateway_path(account_id, gateway_id), do: base_path(account_id) <> "/#{gateway_id}"

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
