defmodule CloudflareApi.AccessCustomPages do
  @moduledoc ~S"""
  Manage Cloudflare Access custom pages for an account.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List access custom pages.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessCustomPages.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create access custom pages.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessCustomPages.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get access custom pages.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessCustomPages.get(client, "account_id", "custom_page_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, custom_page_id) do
    c(client)
    |> Tesla.get(page_path(account_id, custom_page_id))
    |> handle_response()
  end

  @doc ~S"""
  Update access custom pages.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessCustomPages.update(client, "account_id", "custom_page_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, custom_page_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(page_path(account_id, custom_page_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete access custom pages.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessCustomPages.delete(client, "account_id", "custom_page_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, custom_page_id) do
    c(client)
    |> Tesla.delete(page_path(account_id, custom_page_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/custom_pages"
  defp page_path(account_id, custom_page_id), do: base_path(account_id) <> "/#{custom_page_id}"

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
