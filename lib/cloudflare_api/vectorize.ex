defmodule CloudflareApi.Vectorize do
  @moduledoc ~S"""
  Manage Vectorize v2 indexes under `/accounts/:account_id/vectorize/v2/indexes`.
  """

  def list_indexes(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  def create_index(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  def get_index(client, account_id, index_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(index_path(account_id, index_name), opts))
    |> handle_response()
  end

  def delete_index(client, account_id, index_name) do
    c(client)
    |> Tesla.delete(index_path(account_id, index_name), body: %{})
    |> handle_response()
  end

  def insert_vectors(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/insert", params)
    |> handle_response()
  end

  def upsert_vectors(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/upsert", params)
    |> handle_response()
  end

  def delete_vectors_by_ids(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/delete_by_ids", params)
    |> handle_response()
  end

  def get_vectors_by_ids(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/get_by_ids", params)
    |> handle_response()
  end

  def list_vectors(client, account_id, index_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(index_path(account_id, index_name) <> "/list", opts))
    |> handle_response()
  end

  def query(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/query", params)
    |> handle_response()
  end

  def index_info(client, account_id, index_name) do
    c(client)
    |> Tesla.get(index_path(account_id, index_name) <> "/info")
    |> handle_response()
  end

  def create_metadata_index(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/metadata_index/create", params)
    |> handle_response()
  end

  def delete_metadata_index(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/metadata_index/delete", params)
    |> handle_response()
  end

  def list_metadata_indexes(client, account_id, index_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(index_path(account_id, index_name) <> "/metadata_index/list", opts))
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/vectorize/v2/indexes"

  defp index_path(account_id, index_name),
    do: base(account_id) <> "/#{encode(index_name)}"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
