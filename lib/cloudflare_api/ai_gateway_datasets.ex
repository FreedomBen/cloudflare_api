defmodule CloudflareApi.AiGatewayDatasets do
  @moduledoc ~S"""
  Manage AI Gateway datasets under an account and gateway.

  These helpers wrap the `/accounts/:account_id/ai-gateway/gateways/:gateway_id/datasets`
  endpoints, returning `{:ok, result}` / `{:error, errors}` tuples without adding
  caching or heavy abstractions.
  """

  @doc ~S"""
  List datasets for a gateway.

      CloudflareApi.AiGatewayDatasets.list(client, "acc", "gw")
  """
  def list(client, account_id, gateway_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, gateway_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a dataset. `params` is sent as the JSON request body.
  """
  def create(client, account_id, gateway_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, gateway_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a dataset by its identifier.
  """
  def get(client, account_id, gateway_id, dataset_id) do
    c(client)
    |> Tesla.get(dataset_path(account_id, gateway_id, dataset_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a dataset via `PUT`.
  """
  def update(client, account_id, gateway_id, dataset_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(dataset_path(account_id, gateway_id, dataset_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a dataset.
  """
  def delete(client, account_id, gateway_id, dataset_id) do
    c(client)
    |> Tesla.delete(dataset_path(account_id, gateway_id, dataset_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, gateway_id, []), do: base_path(account_id, gateway_id)

  defp list_url(account_id, gateway_id, opts) do
    base_path(account_id, gateway_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, gateway_id) do
    "/accounts/#{account_id}/ai-gateway/gateways/#{gateway_id}/datasets"
  end

  defp dataset_path(account_id, gateway_id, dataset_id) do
    base_path(account_id, gateway_id) <> "/#{dataset_id}"
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
