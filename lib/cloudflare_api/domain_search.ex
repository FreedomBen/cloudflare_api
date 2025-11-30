defmodule CloudflareApi.DomainSearch do
  @moduledoc ~S"""
  Brand Protection domain search helpers.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List matches for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.list_matches(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_matches(client, account_id, opts \\ []) do
    get(client, account_id, "/matches", opts)
  end

  @doc ~S"""
  Download matches for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.download_matches(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def download_matches(client, account_id, opts \\ []) do
    get(client, account_id, "/matches/download", opts)
  end

  @doc ~S"""
  List queries for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.list_queries(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_queries(client, account_id, opts \\ []) do
    get(client, account_id, "/queries", opts)
  end

  @doc ~S"""
  Create query for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.create_query(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_query(client, account_id, params) when is_map(params) do
    post(client, account_id, "/queries", params)
  end

  @doc ~S"""
  Update queries for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.update_queries(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_queries(client, account_id, params) when is_map(params) do
    patch(client, account_id, "/queries", params)
  end

  @doc ~S"""
  Delete queries for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.delete_queries(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_queries(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, account_id, "/queries", params)
  end

  @doc ~S"""
  Bulk create queries for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.bulk_create_queries(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def bulk_create_queries(client, account_id, params) when is_map(params) do
    post(client, account_id, "/queries/bulk", params)
  end

  @doc ~S"""
  Search domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.search(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def search(client, account_id, params) when is_map(params) do
    post(client, account_id, "/search", params)
  end

  @doc ~S"""
  Total queries for domain search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainSearch.total_queries(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def total_queries(client, account_id, opts \\ []) do
    get(client, account_id, "/total-queries", opts)
  end

  defp get(client, account_id, suffix, opts) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id) <> suffix, opts))
    |> handle_response()
  end

  defp post(client, account_id, suffix, params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> suffix, params)
    |> handle_response()
  end

  defp patch(client, account_id, suffix, params) do
    c(client)
    |> Tesla.patch(base_path(account_id) <> suffix, params)
    |> handle_response()
  end

  defp delete(client, account_id, suffix, params) do
    c(client)
    |> Tesla.delete(base_path(account_id) <> suffix, body: params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/brand-protection"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
