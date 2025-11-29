defmodule CloudflareApi.Lists do
  @moduledoc ~S"""
  Manage Cloudflare Filter Lists for an account (`/accounts/:account_id/rules/lists`).
  """

  @doc ~S"""
  List lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  @doc ~S"""
  Create lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Get lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.get(client, "account_id", "list_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, list_id) do
    request(client, :get, list_path(account_id, list_id))
  end

  @doc ~S"""
  Update lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.update(client, "account_id", "list_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, list_id, params) when is_map(params) do
    request(client, :put, list_path(account_id, list_id), params)
  end

  @doc ~S"""
  Delete lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.delete(client, "account_id", "list_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, list_id) do
    request(client, :delete, list_path(account_id, list_id), %{})
  end

  @doc ~S"""
  Get items for lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.get_items(client, "account_id", "list_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_items(client, account_id, list_id, opts \\ []) do
    request(client, :get, items_path(account_id, list_id) <> query(opts))
  end

  @doc ~S"""
  Create items for lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.create_items(client, "account_id", "list_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_items(client, account_id, list_id, params) when is_map(params) do
    request(client, :post, items_path(account_id, list_id), params)
  end

  @doc ~S"""
  Replace items for lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.replace_items(client, "account_id", "list_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def replace_items(client, account_id, list_id, params) when is_map(params) do
    request(client, :put, items_path(account_id, list_id), params)
  end

  @doc ~S"""
  Delete items for lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.delete_items(client, "account_id", "list_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_items(client, account_id, list_id, params) when is_map(params) do
    request(client, :delete, items_path(account_id, list_id), params)
  end

  @doc ~S"""
  Get item for lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.get_item(client, "account_id", "list_id", "item_id")
      {:ok, %{"id" => "example"}}

  """

  def get_item(client, account_id, list_id, item_id) do
    request(client, :get, item_path(account_id, list_id, item_id))
  end

  @doc ~S"""
  Get bulk operation for lists.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Lists.get_bulk_operation(client, "account_id", "operation_id")
      {:ok, %{"id" => "example"}}

  """

  def get_bulk_operation(client, account_id, operation_id) do
    request(client, :get, bulk_path(account_id, operation_id))
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/rules/lists"
  defp list_path(account_id, list_id), do: base_path(account_id) <> "/#{list_id}"
  defp items_path(account_id, list_id), do: list_path(account_id, list_id) <> "/items"

  defp item_path(account_id, list_id, item_id),
    do: items_path(account_id, list_id) <> "/#{item_id}"

  defp bulk_path(account_id, operation_id),
    do: base_path(account_id) <> "/bulk_operations/#{operation_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
      end

    handle_response(result)
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
