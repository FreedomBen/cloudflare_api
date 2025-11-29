defmodule CloudflareApi.D1 do
  @moduledoc ~S"""
  Manage Cloudflare D1 databases.
  """

  @doc ~S"""
  List databases for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.list_databases(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_databases(client, account_id, opts \\ []) do
    request(:get, base_path(account_id), client, query: opts)
  end

  @doc ~S"""
  Create database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.create_database(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_database(client, account_id, params) when is_map(params) do
    request(:post, base_path(account_id), client, body: params)
  end

  @doc ~S"""
  Get database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.get_database(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def get_database(client, account_id, database_id) do
    request(:get, db_path(account_id, database_id), client)
  end

  @doc ~S"""
  Delete database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.delete_database(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_database(client, account_id, database_id) do
    request(:delete, db_path(account_id, database_id), client, body: %{})
  end

  @doc ~S"""
  Update database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.update_database(client, "account_id", %{}, %{})
      {:ok, %{"id" => "example"}}

  """

  def update_database(client, account_id, database_id, params) when is_map(params) do
    request(:put, db_path(account_id, database_id), client, body: params)
  end

  @doc ~S"""
  Update database partial for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.update_database_partial(client, "account_id", %{}, %{})
      {:ok, %{"id" => "example"}}

  """

  def update_database_partial(client, account_id, database_id, params) when is_map(params) do
    request(:patch, db_path(account_id, database_id), client, body: params)
  end

  @doc ~S"""
  Export database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.export_database(client, "account_id", %{}, %{})
      {:ok, %{"id" => "example"}}

  """

  def export_database(client, account_id, database_id, params) when is_map(params) do
    request(:post, db_path(account_id, database_id) <> "/export", client, body: params)
  end

  @doc ~S"""
  Import database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.import_database(client, "account_id", %{}, %{})
      {:ok, %{"id" => "example"}}

  """

  def import_database(client, account_id, database_id, params) when is_map(params) do
    request(:post, db_path(account_id, database_id) <> "/import", client, body: params)
  end

  @doc ~S"""
  Query database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.query_database(client, "account_id", %{}, %{})
      {:ok, %{"id" => "example"}}

  """

  def query_database(client, account_id, database_id, params) when is_map(params) do
    request(:post, db_path(account_id, database_id) <> "/query", client, body: params)
  end

  @doc ~S"""
  Raw query database for d1.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.D1.raw_query_database(client, "account_id", %{}, %{})
      {:ok, %{"id" => "example"}}

  """

  def raw_query_database(client, account_id, database_id, params) when is_map(params) do
    request(:post, db_path(account_id, database_id) <> "/raw", client, body: params)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/d1/database"
  defp db_path(account_id, database_id), do: base_path(account_id) <> "/#{database_id}"

  defp request(method, url, client, opts \\ []) do
    client = c(client)
    query = Keyword.get(opts, :query, [])
    body = Keyword.get(opts, :body, nil)

    case method do
      :get -> Tesla.get(client, url_with_query(url, query))
      :delete -> Tesla.delete(client, url_with_query(url, query), body: body)
      :post -> Tesla.post(client, url_with_query(url, query), body)
      :put -> Tesla.put(client, url_with_query(url, query), body)
      :patch -> Tesla.patch(client, url_with_query(url, query), body)
    end
    |> handle_response()
  end

  defp url_with_query(url, []), do: url
  defp url_with_query(url, query), do: url <> "?" <> CloudflareApi.uri_encode_opts(query)

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
