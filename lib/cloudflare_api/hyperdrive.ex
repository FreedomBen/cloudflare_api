defmodule CloudflareApi.Hyperdrive do
  @moduledoc ~S"""
  Manage Hyperdrive configurations via `/accounts/:account_id/hyperdrive/configs`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List hyperdrive.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Hyperdrive.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  @doc ~S"""
  Create hyperdrive.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Hyperdrive.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Get hyperdrive.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Hyperdrive.get(client, "account_id", "hyperdrive_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, hyperdrive_id) do
    request(client, :get, config_path(account_id, hyperdrive_id))
  end

  @doc ~S"""
  Delete hyperdrive.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Hyperdrive.delete(client, "account_id", "hyperdrive_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, hyperdrive_id) do
    request(client, :delete, config_path(account_id, hyperdrive_id), %{})
  end

  @doc ~S"""
  Update hyperdrive.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Hyperdrive.update(client, "account_id", "hyperdrive_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, hyperdrive_id, params) when is_map(params) do
    request(client, :put, config_path(account_id, hyperdrive_id), params)
  end

  @doc ~S"""
  Patch hyperdrive.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Hyperdrive.patch(client, "account_id", "hyperdrive_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch(client, account_id, hyperdrive_id, params) when is_map(params) do
    request(client, :patch, config_path(account_id, hyperdrive_id), params)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/hyperdrive/configs"
  defp config_path(account_id, id), do: base_path(account_id) <> "/#{id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:put, %{} = params} ->
          Tesla.put(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)
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
