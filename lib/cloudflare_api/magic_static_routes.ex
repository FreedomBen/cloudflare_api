defmodule CloudflareApi.MagicStaticRoutes do
  @moduledoc ~S"""
  Manage Magic static routes (`/accounts/:account_id/magic/routes`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, base(account_id) <> query(opts))
  end

  @doc ~S"""
  Create magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.create(client, "account_id", %{}, [])
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params, opts \\ []) when is_map(params) do
    request(client, :post, base(account_id) <> query(opts), params)
  end

  @doc ~S"""
  Update many for magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.update_many(client, "account_id", %{}, [])
      {:ok, %{"id" => "example"}}

  """

  def update_many(client, account_id, params, opts \\ []) when is_map(params) do
    request(client, :put, base(account_id) <> query(opts), params)
  end

  @doc ~S"""
  Delete many for magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.delete_many(client, "account_id", %{}, [])
      {:ok, %{"id" => "example"}}

  """

  def delete_many(client, account_id, params, opts \\ []) when is_map(params) do
    request(client, :delete, base(account_id) <> query(opts), params)
  end

  @doc ~S"""
  Get magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.get(client, "account_id", "route_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, route_id) do
    request(client, :get, route_path(account_id, route_id))
  end

  @doc ~S"""
  Update magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.update(client, "account_id", "route_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, route_id, params) when is_map(params) do
    request(client, :put, route_path(account_id, route_id), params)
  end

  @doc ~S"""
  Delete magic static routes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicStaticRoutes.delete(client, "account_id", "route_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, route_id) do
    request(client, :delete, route_path(account_id, route_id))
  end

  defp base(account_id), do: "/accounts/#{account_id}/magic/routes"
  defp route_path(account_id, route_id), do: base(account_id) <> "/#{route_id}"
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
        {:delete, nil} -> Tesla.delete(client, url)
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
