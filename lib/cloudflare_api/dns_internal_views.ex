defmodule CloudflareApi.DnsInternalViews do
  @moduledoc ~S"""
  Manage internal DNS views via `/accounts/:account_id/dns_settings/views`.
  """

  use CloudflareApi.Typespecs
  @type client :: CloudflareApi.client()
  @type account_id :: CloudflareApi.id()
  @type view_id :: String.t()
  @type result :: CloudflareApi.result(term())

  @doc ~S"""
  List dns internal views.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DnsInternalViews.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  @spec list(client(), account_id()) :: result()
  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create dns internal views.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DnsInternalViews.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  @spec create(client(), account_id(), map()) :: result()
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get dns internal views.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DnsInternalViews.get(client, "account_id", "view_id")
      {:ok, %{"id" => "example"}}

  """

  @spec get(client(), account_id(), view_id()) :: result()
  def get(client, account_id, view_id) do
    request(client, :get, view_path(account_id, view_id))
  end

  @doc ~S"""
  Update dns internal views.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DnsInternalViews.update(client, "account_id", "view_id", %{})
      {:ok, %{"id" => "example"}}

  """

  @spec update(client(), account_id(), view_id(), map()) :: result()
  def update(client, account_id, view_id, params) when is_map(params) do
    request(client, :patch, view_path(account_id, view_id), params)
  end

  @doc ~S"""
  Delete dns internal views.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DnsInternalViews.delete(client, "account_id", "view_id")
      {:ok, %{"id" => "example"}}

  """

  @spec delete(client(), account_id(), view_id()) :: result()
  def delete(client, account_id, view_id) do
    request(client, :delete, view_path(account_id, view_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/dns_settings/views"
  defp view_path(account_id, view_id), do: base(account_id) <> "/#{view_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
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
