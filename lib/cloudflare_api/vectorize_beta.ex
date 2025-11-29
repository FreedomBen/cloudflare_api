defmodule CloudflareApi.VectorizeBeta do
  @moduledoc ~S"""
  Deprecated Vectorize API wrapper under `/accounts/:account_id/vectorize/indexes`.
  """

  @doc ~S"""
  List indexes for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.list_indexes(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_indexes(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create index for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.create_index(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_index(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update index for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.update_index(client, "account_id", "index_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_index(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(index_path(account_id, index_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Get index for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.get_index(client, "account_id", "index_name", [])
      {:ok, %{"id" => "example"}}

  """

  def get_index(client, account_id, index_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(index_path(account_id, index_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete index for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.delete_index(client, "account_id", "index_name")
      {:ok, %{"id" => "example"}}

  """

  def delete_index(client, account_id, index_name) do
    c(client)
    |> Tesla.delete(index_path(account_id, index_name), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Insert vectors for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.insert_vectors(client, "account_id", "index_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def insert_vectors(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/insert", params)
    |> handle_response()
  end

  @doc ~S"""
  Upsert vectors for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.upsert_vectors(client, "account_id", "index_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def upsert_vectors(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/upsert", params)
    |> handle_response()
  end

  @doc ~S"""
  Delete vectors by ids for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.delete_vectors_by_ids(client, "account_id", "index_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_vectors_by_ids(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/delete-by-ids", params)
    |> handle_response()
  end

  @doc ~S"""
  Get vectors by ids for vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.get_vectors_by_ids(client, "account_id", "index_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def get_vectors_by_ids(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/get-by-ids", params)
    |> handle_response()
  end

  @doc ~S"""
  Query vectorize beta.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.VectorizeBeta.query(client, "account_id", "index_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def query(client, account_id, index_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(index_path(account_id, index_name) <> "/query", params)
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/vectorize/indexes"
  defp index_path(account_id, name), do: base(account_id) <> "/#{encode(name)}"
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
