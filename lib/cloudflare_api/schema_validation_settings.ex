defmodule CloudflareApi.SchemaValidationSettings do
  @moduledoc ~S"""
  Manage schema validation settings and per-operation overrides.
  """

  @doc ~S"""
  Get settings for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.get_settings(client, "zone_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_settings(client, zone_id, opts \\ []) do
    fetch(client, settings_path(zone_id), opts)
  end

  @doc ~S"""
  Patch settings for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.patch_settings(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update settings for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.update_settings(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List operations for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.list_operations(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_operations(client, zone_id, opts \\ []) do
    fetch(client, operation_settings_path(zone_id), opts)
  end

  @doc ~S"""
  Bulk patch operations for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.bulk_patch_operations(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def bulk_patch_operations(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(operation_settings_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get operation setting for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.get_operation_setting(client, "zone_id", "operation_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_operation_setting(client, zone_id, operation_id, opts \\ []) do
    fetch(client, single_operation_path(zone_id, operation_id), opts)
  end

  @doc ~S"""
  Update operation setting for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.update_operation_setting(client, "zone_id", "operation_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_operation_setting(client, zone_id, operation_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(single_operation_path(zone_id, operation_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete operation setting for schema validation settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidationSettings.delete_operation_setting(client, "zone_id", "operation_id")
      {:ok, %{"id" => "example"}}

  """

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
