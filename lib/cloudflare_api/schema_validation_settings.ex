defmodule CloudflareApi.SchemaValidationSettings do
  @moduledoc ~S"""
  Manage schema validation settings and per-operation overrides.
  """

  def get_settings(client, zone_id, opts \\ []) do
    fetch(client, settings_path(zone_id), opts)
  end

  def patch_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id), params)
    |> handle_response()
  end

  def update_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(zone_id), params)
    |> handle_response()
  end

  def list_operations(client, zone_id, opts \\ []) do
    fetch(client, operation_settings_path(zone_id), opts)
  end

  def bulk_patch_operations(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(operation_settings_path(zone_id), params)
    |> handle_response()
  end

  def get_operation_setting(client, zone_id, operation_id, opts \\ []) do
    fetch(client, single_operation_path(zone_id, operation_id), opts)
  end

  def update_operation_setting(client, zone_id, operation_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(single_operation_path(zone_id, operation_id), params)
    |> handle_response()
  end

  def delete_operation_setting(client, zone_id, operation_id) do
    c(client)
    |> Tesla.delete(single_operation_path(zone_id, operation_id), body: %{})
    |> handle_response()
  end

  defp settings_path(zone_id), do: "/zones/#{zone_id}/schema_validation/settings"
  defp operation_settings_path(zone_id), do: settings_path(zone_id) <> "/operations"
  defp single_operation_path(zone_id, operation_id),
    do: operation_settings_path(zone_id) <> "/#{encode(operation_id)}"

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
