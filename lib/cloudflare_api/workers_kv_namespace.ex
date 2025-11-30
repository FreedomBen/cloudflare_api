defmodule CloudflareApi.WorkersKvNamespace do
  @moduledoc ~S"""
  Manage Workers KV namespaces plus key, metadata, and bulk operations.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List namespaces (`GET /accounts/:account_id/storage/kv/namespaces`).

  Supports pagination options such as `:page` and `:per_page`.
  """
  def list_namespaces(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a namespace (`POST /accounts/:account_id/storage/kv/namespaces`).
  """
  def create_namespace(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a namespace (`DELETE .../namespaces/:namespace_id`).
  """
  def delete_namespace(client, account_id, namespace_id) do
    c(client)
    |> Tesla.delete(namespace_path(account_id, namespace_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch namespace metadata (`GET .../namespaces/:namespace_id`).
  """
  def get_namespace(client, account_id, namespace_id) do
    c(client)
    |> Tesla.get(namespace_path(account_id, namespace_id))
    |> handle_response()
  end

  @doc ~S"""
  Rename a namespace (`PUT .../namespaces/:namespace_id`).
  """
  def rename_namespace(client, account_id, namespace_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(namespace_path(account_id, namespace_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Bulk write key/value pairs (`PUT .../bulk`).
  """
  def write_bulk(client, account_id, namespace_id, entries)
      when is_list(entries) or is_map(entries) do
    c(client)
    |> Tesla.put(bulk_path(account_id, namespace_id), entries)
    |> handle_response()
  end

  @doc ~S"""
  Bulk delete (deprecated endpoint) (`DELETE .../bulk`).
  """
  def delete_bulk_deprecated(client, account_id, namespace_id, entries) do
    c(client)
    |> Tesla.delete(bulk_path(account_id, namespace_id), body: entries)
    |> handle_response()
  end

  @doc ~S"""
  Bulk delete (`POST .../bulk/delete`).
  """
  def delete_bulk(client, account_id, namespace_id, entries) do
    c(client)
    |> Tesla.post(bulk_delete_path(account_id, namespace_id), entries)
    |> handle_response()
  end

  @doc ~S"""
  Bulk read values (`POST .../bulk/get`).
  """
  def read_bulk(client, account_id, namespace_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(bulk_get_path(account_id, namespace_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List keys within a namespace (`GET .../keys`).

  Supports filters such as `:limit`, `:cursor`, and `:prefix`.
  """
  def list_keys(client, account_id, namespace_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(keys_path(account_id, namespace_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Read key metadata (`GET .../metadata/:key_name`).
  """
  def read_metadata(client, account_id, namespace_id, key_name) do
    c(client)
    |> Tesla.get(metadata_path(account_id, namespace_id, key_name))
    |> handle_response()
  end

  @doc ~S"""
  Delete a key (`DELETE .../values/:key_name`).
  """
  def delete_value(client, account_id, namespace_id, key_name) do
    c(client)
    |> Tesla.delete(value_path(account_id, namespace_id, key_name), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Read a key's value (`GET .../values/:key_name`).
  """
  def read_value(client, account_id, namespace_id, key_name, opts \\ []) do
    case c(client)
         |> Tesla.get(with_query(value_path(account_id, namespace_id, key_name), opts)) do
      {:ok, %Tesla.Env{status: status, body: body}} when status in 200..299 -> {:ok, body}
      other -> handle_response(other)
    end
  end

  @doc ~S"""
  Write a key's value (`PUT .../values/:key_name`).

  Accepts either raw IO data (for octet-stream uploads) or a `Tesla.Multipart`
  struct when metadata is required. Query options such as `:expiration` and
  `:expiration_ttl` should be passed via `opts`. Additional request headers can
  be provided via `headers`.
  """
  def write_value(client, account_id, namespace_id, key_name, body, opts \\ [], headers \\ []) do
    c(client)
    |> Tesla.put(
      with_query(value_path(account_id, namespace_id, key_name), opts),
      body,
      headers: headers
    )
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/storage/kv/namespaces"

  defp namespace_path(account_id, namespace_id),
    do: base_path(account_id) <> "/#{encode(namespace_id)}"

  defp bulk_path(account_id, namespace_id),
    do: namespace_path(account_id, namespace_id) <> "/bulk"

  defp bulk_delete_path(account_id, namespace_id),
    do: namespace_path(account_id, namespace_id) <> "/bulk/delete"

  defp bulk_get_path(account_id, namespace_id),
    do: namespace_path(account_id, namespace_id) <> "/bulk/get"

  defp keys_path(account_id, namespace_id),
    do: namespace_path(account_id, namespace_id) <> "/keys"

  defp metadata_path(account_id, namespace_id, key_name),
    do: namespace_path(account_id, namespace_id) <> "/metadata/#{encode(key_name)}"

  defp value_path(account_id, namespace_id, key_name),
    do: namespace_path(account_id, namespace_id) <> "/values/#{encode(key_name)}"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
