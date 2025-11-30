defmodule CloudflareApi.DomainIntelligence do
  @moduledoc ~S"""
  Domain intelligence helpers (`/accounts/:account_id/intel/domain` and `/bulk`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Get domain intelligence.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainIntelligence.get(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/intel/domain" <> query_suffix(opts))
  end

  @doc ~S"""
  Bulk get for domain intelligence.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DomainIntelligence.bulk_get(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def bulk_get(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/intel/domain/bulk" <> query_suffix(opts))
  end

  defp request(client, url) do
    c(client)
    |> Tesla.get(url)
    |> handle()
  end

  defp query_suffix([]), do: ""

  defp query_suffix(opts) do
    flattened =
      Enum.flat_map(opts, fn
        {key, values} when is_list(values) ->
          Enum.map(values, &{key, &1})

        pair ->
          [pair]
      end)

    "?" <> CloudflareApi.uri_encode_opts(flattened)
  end

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
