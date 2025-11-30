defmodule CloudflareApi.ConnectivityServices do
  @moduledoc ~S"""
  Manage Connectivity Services directory entries.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List connectivity services.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ConnectivityServices.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(account_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create connectivity services.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ConnectivityServices.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get connectivity services.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ConnectivityServices.get(client, "account_id", "service_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, service_id) do
    c(client)
    |> Tesla.get(service_path(account_id, service_id))
    |> handle_response()
  end

  @doc ~S"""
  Update connectivity services.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ConnectivityServices.update(client, "account_id", "service_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, service_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(service_path(account_id, service_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete connectivity services.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ConnectivityServices.delete(client, "account_id", "service_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, service_id) do
    c(client)
    |> Tesla.delete(service_path(account_id, service_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/connectivity/directory/services"
  defp service_path(account_id, service_id), do: base_path(account_id) <> "/#{service_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
