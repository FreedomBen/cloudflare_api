defmodule CloudflareApi.Category do
  @moduledoc ~S"""
  Manage Cloudforce One event categories.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(categories_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Catalog category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.catalog(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def catalog(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/cloudforce-one/events/categories/catalog")
    |> handle_response()
  end

  @doc ~S"""
  Create category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/create", params)
    |> handle_response()
  end

  @doc ~S"""
  Get category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.get(client, "account_id", "category_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, category_id) do
    c(client)
    |> Tesla.get(category_path(account_id, category_id))
    |> handle_response()
  end

  @doc ~S"""
  Update patch for category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.update_patch(client, "account_id", "category_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_patch(client, account_id, category_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(category_path(account_id, category_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update post for category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.update_post(client, "account_id", "category_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_post(client, account_id, category_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(category_path(account_id, category_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete category.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Category.delete(client, "account_id", "category_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, category_id) do
    c(client)
    |> Tesla.delete(category_path(account_id, category_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/cloudforce-one/events/categories"

  defp categories_url(account_id, []), do: base_path(account_id)

  defp categories_url(account_id, opts),
    do: base_path(account_id) <> "?" <> encode_list_opts(opts)

  defp category_path(account_id, category_id), do: base_path(account_id) <> "/#{category_id}"

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp encode_list_opts(opts) do
    opts
    |> Enum.flat_map(fn
      {key, value} when is_list(value) -> Enum.map(value, &{key, &1})
      pair -> [pair]
    end)
    |> URI.encode_query()
  end

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
