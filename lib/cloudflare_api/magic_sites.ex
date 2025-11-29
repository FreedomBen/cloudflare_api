defmodule CloudflareApi.MagicSites do
  @moduledoc ~S"""
  Manage Magic Sites (`/accounts/:account_id/magic/sites`).
  """

  @doc ~S"""
  List magic sites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSites.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, base(account_id) <> query(opts))
  end

  @doc ~S"""
  Create magic sites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSites.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get magic sites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSites.get(client, "account_id", "site_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, site_id) do
    request(client, :get, site_path(account_id, site_id))
  end

  @doc ~S"""
  Update magic sites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSites.update(client, "account_id", "site_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, site_id, params) when is_map(params) do
    request(client, :put, site_path(account_id, site_id), params)
  end

  @doc ~S"""
  Patch magic sites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSites.patch(client, "account_id", "site_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, site_id, params) when is_map(params) do
    request(client, :patch, site_path(account_id, site_id), params)
  end

  @doc ~S"""
  Delete magic sites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSites.delete(client, "account_id", "site_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, site_id) do
    request(client, :delete, site_path(account_id, site_id))
  end

  defp base(account_id), do: "/accounts/#{account_id}/magic/sites"
  defp site_path(account_id, site_id), do: base(account_id) <> "/#{site_id}"
  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
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
