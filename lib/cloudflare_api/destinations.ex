defmodule CloudflareApi.Destinations do
  @moduledoc ~S"""
  Workers Observability destinations under
  `/accounts/:account_id/workers/observability/destinations`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List destinations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Destinations.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create destinations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Destinations.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Update destinations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Destinations.update(client, "account_id", "slug", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, slug, params) when is_map(params) do
    request(client, :patch, destination_path(account_id, slug), params)
  end

  @doc ~S"""
  Delete destinations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Destinations.delete(client, "account_id", "slug")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, slug) do
    request(client, :delete, destination_path(account_id, slug), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/workers/observability/destinations"
  defp destination_path(account_id, slug), do: base(account_id) <> "/#{slug}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
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
