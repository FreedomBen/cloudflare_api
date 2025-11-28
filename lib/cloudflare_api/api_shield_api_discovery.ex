defmodule CloudflareApi.ApiShieldApiDiscovery do
  @moduledoc ~S"""
  Wraps the API Shield API Discovery endpoints for a zone.

  These helpers expose access to discovered operations and the generated
  OpenAPI document.
  """

  @doc ~S"""
  Retrieve the discovered operations as an OpenAPI document
  (`GET /zones/:zone_id/api_gateway/discovery`).
  """
  def fetch_openapi(client, zone_id) do
    c(client)
    |> Tesla.get("/zones/#{zone_id}/api_gateway/discovery")
    |> handle_response()
  end

  @doc ~S"""
  List discovered operations (`GET /discovery/operations`). Supports filters via `opts`.
  """
  def list_operations(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(operations_url(zone_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Patch discovered operations in bulk (`PATCH /discovery/operations`).
  Provide a map that matches the API Shield schema.
  """
  def patch_operations(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch("/zones/#{zone_id}/api_gateway/discovery/operations", params)
    |> handle_response()
  end

  @doc ~S"""
  Patch an individual discovered operation (`PATCH /discovery/operations/:operation_id`).
  """
  def update_operation(client, zone_id, operation_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(operation_path(zone_id, operation_id), params)
    |> handle_response()
  end

  defp operations_url(zone_id, []), do: "/zones/#{zone_id}/api_gateway/discovery/operations"

  defp operations_url(zone_id, opts) do
    "/zones/#{zone_id}/api_gateway/discovery/operations?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp operation_path(zone_id, operation_id) do
    "/zones/#{zone_id}/api_gateway/discovery/operations/#{operation_id}"
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
