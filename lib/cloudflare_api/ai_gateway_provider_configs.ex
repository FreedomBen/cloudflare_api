defmodule CloudflareApi.AiGatewayProviderConfigs do
  @moduledoc ~S"""
  Manage provider configurations for an AI Gateway.

  These functions wrap `/accounts/:account_id/ai-gateway/gateways/:gateway_id/provider_configs`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List provider configs. Optional filters can be supplied via `opts`.
  """
  def list(client, account_id, gateway_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, gateway_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a provider config.
  """
  def create(client, account_id, gateway_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, gateway_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update a provider config (`PUT`).
  """
  def update(client, account_id, gateway_id, config_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(config_path(account_id, gateway_id, config_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a provider config.
  """
  def delete(client, account_id, gateway_id, config_id) do
    c(client)
    |> Tesla.delete(config_path(account_id, gateway_id, config_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, gateway_id, []), do: base_path(account_id, gateway_id)

  defp list_url(account_id, gateway_id, opts) do
    base_path(account_id, gateway_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, gateway_id) do
    "/accounts/#{account_id}/ai-gateway/gateways/#{gateway_id}/provider_configs"
  end

  defp config_path(account_id, gateway_id, config_id) do
    base_path(account_id, gateway_id) <> "/#{config_id}"
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
