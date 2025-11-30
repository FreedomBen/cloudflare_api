defmodule CloudflareApi.CustomOriginTrustStore do
  @moduledoc ~S"""
  Manage custom origin trust store certificates for a zone.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List custom origin trust store.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomOriginTrustStore.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Create custom origin trust store.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomOriginTrustStore.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get custom origin trust store.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomOriginTrustStore.get(client, "zone_id", "store_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, store_id) do
    c(client)
    |> Tesla.get(item_path(zone_id, store_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete custom origin trust store.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomOriginTrustStore.delete(client, "zone_id", "store_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, store_id) do
    c(client)
    |> Tesla.delete(item_path(zone_id, store_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/acm/custom_trust_store"
  defp item_path(zone_id, store_id), do: base_path(zone_id) <> "/#{store_id}"

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
