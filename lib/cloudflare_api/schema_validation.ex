defmodule CloudflareApi.SchemaValidation do
  @moduledoc ~S"""
  Manage schema validation schemas for a zone (`/zones/:zone_id/schema_validation`).
  """

  @doc ~S"""
  List schemas for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.list_schemas(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_schemas(client, zone_id, opts \\ []) do
    fetch(client, base_path(zone_id) <> "/schemas", opts)
  end

  @doc ~S"""
  Create schema for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.create_schema(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_schema(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/schemas", params)
    |> handle_response()
  end

  @doc ~S"""
  Get schema for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.get_schema(client, "zone_id", "schema_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_schema(client, zone_id, schema_id, opts \\ []) do
    fetch(client, schema_path(zone_id, schema_id), opts)
  end

  @doc ~S"""
  Update schema for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.update_schema(client, "zone_id", "schema_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_schema(client, zone_id, schema_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(schema_path(zone_id, schema_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete schema for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.delete_schema(client, "zone_id", "schema_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_schema(client, zone_id, schema_id) do
    c(client)
    |> Tesla.delete(schema_path(zone_id, schema_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List hosts for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.list_hosts(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_hosts(client, zone_id, opts \\ []) do
    fetch(client, base_path(zone_id) <> "/schemas/hosts", opts)
  end

  @doc ~S"""
  Extract operations for schema validation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SchemaValidation.extract_operations(client, "zone_id", "schema_id", [])
      {:ok, %{"id" => "example"}}

  """

  def extract_operations(client, zone_id, schema_id, opts \\ []) do
    fetch(client, schema_path(zone_id, schema_id) <> "/operations", opts)
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/schema_validation"
  defp schema_path(zone_id, schema_id), do: base_path(zone_id) <> "/schemas/#{encode(schema_id)}"

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
