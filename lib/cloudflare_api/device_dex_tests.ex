defmodule CloudflareApi.DeviceDexTests do
  @moduledoc ~S"""
  Manage Device DEX tests via `/accounts/:account_id/dex/devices/dex_tests`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List device dex tests.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DeviceDexTests.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create device dex tests.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DeviceDexTests.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get device dex tests.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DeviceDexTests.get(client, "account_id", "dex_test_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, dex_test_id) do
    request(client, :get, test_path(account_id, dex_test_id))
  end

  @doc ~S"""
  Update device dex tests.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DeviceDexTests.update(client, "account_id", "dex_test_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, dex_test_id, params) when is_map(params) do
    request(client, :put, test_path(account_id, dex_test_id), params)
  end

  @doc ~S"""
  Delete device dex tests.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DeviceDexTests.delete(client, "account_id", "dex_test_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, dex_test_id) do
    request(client, :delete, test_path(account_id, dex_test_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/dex/devices/dex_tests"
  defp test_path(account_id, dex_test_id), do: base(account_id) <> "/#{dex_test_id}"

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
