defmodule CloudflareApi.ApiShieldEndpointManagement do
  @moduledoc ~S"""
  Thin wrappers around the API Shield Endpoint Management endpoints for a zone.

  Functions map directly to `/zones/:zone_id/api_gateway/operations*` paths and
  return `{:ok, result}` / `{:error, errors}` tuples.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List operations configured on a zone.
  """
  def list_operations(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(zone_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Bulk create operations (`POST /operations`).
  """
  def create_operations(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Create a single operation (`POST /operations/item`).
  """
  def create_operation(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/item", params)
    |> handle_response()
  end

  @doc ~S"""
  Bulk delete operations (`DELETE /operations`).
  """
  def delete_operations(client, zone_id, params \\ %{}) do
    c(client)
    |> Tesla.delete(base_path(zone_id), body: params)
    |> handle_response()
  end

  @doc ~S"""
  Get a single operation.
  """
  def get_operation(client, zone_id, operation_id) do
    c(client)
    |> Tesla.get(operation_path(zone_id, operation_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a single operation.
  """
  def delete_operation(client, zone_id, operation_id) do
    c(client)
    |> Tesla.delete(operation_path(zone_id, operation_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch the generated OpenAPI schemas for the zone.
  """
  def fetch_schemas(client, zone_id) do
    c(client)
    |> Tesla.get("/zones/#{zone_id}/api_gateway/schemas")
    |> handle_response()
  end

  defp list_url(zone_id, []), do: base_path(zone_id)

  defp list_url(zone_id, opts) do
    base_path(zone_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/api_gateway/operations"
  defp operation_path(zone_id, operation_id), do: base_path(zone_id) <> "/#{operation_id}"

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
