defmodule CloudflareApi.CatalogSync do
  @moduledoc ~S"""
  Manage Catalog Syncs for Magic Cloud.
  """

  @doc ~S"""
  List catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.create(client, "account_id", %{}, [])
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params, headers \\ []) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params, headers: headers)
    |> handle_response()
  end

  @doc ~S"""
  Prebuilt policies for catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.prebuilt_policies(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def prebuilt_policies(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(account_id) <> "/prebuilt-policies" <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Get catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.get(client, "account_id", "sync_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, sync_id) do
    c(client)
    |> Tesla.get(sync_path(account_id, sync_id))
    |> handle_response()
  end

  @doc ~S"""
  Update catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.update(client, "account_id", "sync_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, sync_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(sync_path(account_id, sync_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Patch catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.patch(client, "account_id", "sync_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, sync_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(sync_path(account_id, sync_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.delete(client, "account_id", "sync_id", [])
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, sync_id, opts \\ []) do
    c(client)
    |> Tesla.delete(sync_path(account_id, sync_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Refresh catalog sync.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CatalogSync.refresh(client, "account_id", "sync_id")
      {:ok, %{"id" => "example"}}

  """

  def refresh(client, account_id, sync_id) do
    c(client)
    |> Tesla.post(sync_path(account_id, sync_id) <> "/refresh", %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/magic/cloud/catalog-syncs"
  defp sync_path(account_id, sync_id), do: base_path(account_id) <> "/#{sync_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
