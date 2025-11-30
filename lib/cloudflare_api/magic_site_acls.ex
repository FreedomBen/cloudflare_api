defmodule CloudflareApi.MagicSiteAcls do
  @moduledoc ~S"""
  Manage Magic Site ACLs (`/accounts/:account_id/magic/sites/:site_id/acls`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List magic site acls.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSiteAcls.list(client, "account_id", "site_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, site_id, opts \\ []) do
    request(client, :get, base(account_id, site_id) <> query(opts))
  end

  @doc ~S"""
  Create magic site acls.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSiteAcls.create(client, "account_id", "site_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, site_id, params) when is_map(params) do
    request(client, :post, base(account_id, site_id), params)
  end

  @doc ~S"""
  Get magic site acls.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSiteAcls.get(client, "account_id", "site_id", "acl_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, site_id, acl_id) do
    request(client, :get, acl_path(account_id, site_id, acl_id))
  end

  @doc ~S"""
  Update magic site acls.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSiteAcls.update(client, "account_id", "site_id", "acl_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, site_id, acl_id, params) when is_map(params) do
    request(client, :put, acl_path(account_id, site_id, acl_id), params)
  end

  @doc ~S"""
  Patch magic site acls.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSiteAcls.patch(client, "account_id", "site_id", "acl_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, site_id, acl_id, params) when is_map(params) do
    request(client, :patch, acl_path(account_id, site_id, acl_id), params)
  end

  @doc ~S"""
  Delete magic site acls.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicSiteAcls.delete(client, "account_id", "site_id", "acl_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, site_id, acl_id) do
    request(client, :delete, acl_path(account_id, site_id, acl_id))
  end

  defp base(account_id, site_id), do: "/accounts/#{account_id}/magic/sites/#{site_id}/acls"

  defp acl_path(account_id, site_id, acl_id),
    do: base(account_id, site_id) <> "/#{acl_id}"

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
