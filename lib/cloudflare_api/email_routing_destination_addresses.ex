defmodule CloudflareApi.EmailRoutingDestinationAddresses do
  @moduledoc ~S"""
  Manage email routing destination addresses under
  `/accounts/:account_id/email/routing/addresses`.
  """

  @doc ~S"""
  List email routing destination addresses.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingDestinationAddresses.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create email routing destination addresses.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingDestinationAddresses.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get email routing destination addresses.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingDestinationAddresses.get(client, "account_id", "destination_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, destination_id) do
    request(client, :get, address_path(account_id, destination_id))
  end

  @doc ~S"""
  Delete email routing destination addresses.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingDestinationAddresses.delete(client, "account_id", "destination_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, destination_id) do
    request(client, :delete, address_path(account_id, destination_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/email/routing/addresses"
  defp address_path(account_id, id), do: base(account_id) <> "/#{id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
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
