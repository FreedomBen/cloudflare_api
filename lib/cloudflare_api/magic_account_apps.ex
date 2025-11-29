defmodule CloudflareApi.MagicAccountApps do
  @moduledoc ~S"""
  Manage Magic account applications (`/accounts/:account_id/magic/apps`).
  """

  @doc ~S"""
  List magic account apps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicAccountApps.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create magic account apps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicAccountApps.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get magic account apps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicAccountApps.get(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id) do
    request(client, :get, app_path(account_id, app_id))
  end

  @doc ~S"""
  Update magic account apps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicAccountApps.update(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, app_id, params) when is_map(params) do
    request(client, :put, app_path(account_id, app_id), params)
  end

  @doc ~S"""
  Patch magic account apps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicAccountApps.patch(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, app_id, params) when is_map(params) do
    request(client, :patch, app_path(account_id, app_id), params)
  end

  @doc ~S"""
  Delete magic account apps.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicAccountApps.delete(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, app_id) do
    request(client, :delete, app_path(account_id, app_id))
  end

  defp base(account_id), do: "/accounts/#{account_id}/magic/apps"
  defp app_path(account_id, app_id), do: base(account_id) <> "/#{app_id}"

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
