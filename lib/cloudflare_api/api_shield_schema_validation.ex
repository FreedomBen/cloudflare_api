defmodule CloudflareApi.ApiShieldSchemaValidation do
  @moduledoc ~S"""
  Wraps API Shield Schema Validation 2.0 endpoints for a zone.

  Includes helpers for zone-level settings, operation-level settings, and user
  schema management.
  """

  # Zone-level settings
  def get_zone_settings(client, zone_id) do
    c(client)
    |> Tesla.get(zone_settings_path(zone_id))
    |> handle_response()
  end

  def patch_zone_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(zone_settings_path(zone_id), params)
    |> handle_response()
  end

  def update_zone_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(zone_settings_path(zone_id), params)
    |> handle_response()
  end

  # Operation-level settings
  def patch_operations_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch("/zones/#{zone_id}/api_gateway/operations/schema_validation", params)
    |> handle_response()
  end

  def get_operation_settings(client, zone_id, operation_id) do
    c(client)
    |> Tesla.get(operation_settings_path(zone_id, operation_id))
    |> handle_response()
  end

  def update_operation_settings(client, zone_id, operation_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(operation_settings_path(zone_id, operation_id), params)
    |> handle_response()
  end

  # User schemas
  def list_user_schemas(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(user_schemas_url(zone_id, opts))
    |> handle_response()
  end

  def create_user_schema(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(user_schemas_path(zone_id), params)
    |> handle_response()
  end

  def list_user_schema_hosts(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(user_schemas_host_url(zone_id, opts))
    |> handle_response()
  end

  def get_user_schema(client, zone_id, schema_id) do
    c(client)
    |> Tesla.get(user_schema_path(zone_id, schema_id))
    |> handle_response()
  end

  def delete_user_schema(client, zone_id, schema_id) do
    c(client)
    |> Tesla.delete(user_schema_path(zone_id, schema_id), body: %{})
    |> handle_response()
  end

  def patch_user_schema(client, zone_id, schema_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(user_schema_path(zone_id, schema_id), params)
    |> handle_response()
  end

  def extract_operations(client, zone_id, schema_id) do
    c(client)
    |> Tesla.get(user_schema_path(zone_id, schema_id) <> "/operations")
    |> handle_response()
  end

  # Helpers
  defp zone_settings_path(zone_id), do: "/zones/#{zone_id}/api_gateway/settings/schema_validation"

  defp operation_settings_path(zone_id, operation_id) do
    "/zones/#{zone_id}/api_gateway/operations/#{operation_id}/schema_validation"
  end

  defp user_schemas_path(zone_id), do: "/zones/#{zone_id}/api_gateway/user_schemas"
  defp user_schema_path(zone_id, schema_id), do: user_schemas_path(zone_id) <> "/#{schema_id}"

  defp user_schemas_url(zone_id, []), do: user_schemas_path(zone_id)

  defp user_schemas_url(zone_id, opts) do
    user_schemas_path(zone_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp user_schemas_host_url(zone_id, []), do: user_schemas_path(zone_id) <> "/hosts"

  defp user_schemas_host_url(zone_id, opts) do
    user_schemas_path(zone_id) <> "/hosts?" <> CloudflareApi.uri_encode_opts(opts)
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
