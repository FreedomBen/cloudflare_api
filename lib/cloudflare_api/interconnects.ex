defmodule CloudflareApi.Interconnects do
  @moduledoc ~S"""
  Manage Cloudflare Network Interconnects via `/accounts/:account_id/cni/interconnects`.
  """

  @doc ~S"""
  List interconnects.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Interconnects.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, base_path(account_id) <> query_suffix(opts))
  end

  @doc ~S"""
  Create interconnects.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Interconnects.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Get interconnects.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Interconnects.get(client, "account_id", "interconnect_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, interconnect_id) do
    request(client, :get, interconnect_path(account_id, interconnect_id))
  end

  @doc ~S"""
  Delete interconnects.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Interconnects.delete(client, "account_id", "interconnect_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, interconnect_id) do
    request(client, :delete, interconnect_path(account_id, interconnect_id), %{})
  end

  @doc ~S"""
  Get status for interconnects.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Interconnects.get_status(client, "account_id", "interconnect_id")
      {:ok, %{"id" => "example"}}

  """

  def get_status(client, account_id, interconnect_id) do
    request(client, :get, interconnect_path(account_id, interconnect_id) <> "/status")
  end

  @doc ~S"""
  Get loa for interconnects.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Interconnects.get_loa(client, "account_id", "interconnect_id")
      {:ok, %{"id" => "example"}}

  """

  def get_loa(client, account_id, interconnect_id) do
    c(client)
    |> Tesla.get(interconnect_path(account_id, interconnect_id) <> "/loa")
    |> handle_binary_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/cni/interconnects"

  defp interconnect_path(account_id, interconnect_id),
    do: base_path(account_id) <> "/#{interconnect_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

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

  defp handle_binary_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_binary_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}),
    do: {:error, errors}

  defp handle_binary_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
