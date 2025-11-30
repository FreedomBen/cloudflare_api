defmodule CloudflareApi.DurableObjectsNamespace do
  @moduledoc ~S"""
  Durable Objects namespace helpers (`/workers/durable_objects/namespaces`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List namespaces for durable objects namespace.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DurableObjectsNamespace.list_namespaces(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_namespaces(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      "/accounts/#{account_id}/workers/durable_objects/namespaces" <> query_suffix(opts)
    )
    |> handle()
  end

  @doc ~S"""
  List objects for durable objects namespace.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DurableObjectsNamespace.list_objects(client, "account_id", "namespace_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_objects(client, account_id, namespace_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      "/accounts/#{account_id}/workers/durable_objects/namespaces/#{namespace_id}/objects" <>
        query_suffix(opts)
    )
    |> handle()
  end

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
