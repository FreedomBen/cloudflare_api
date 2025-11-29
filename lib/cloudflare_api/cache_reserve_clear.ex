defmodule CloudflareApi.CacheReserveClear do
  @moduledoc ~S"""
  Inspect and trigger Smart Shield Cache Reserve Clear jobs for a zone.
  """

  @doc ~S"""
  Get cache reserve clear.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CacheReserveClear.get(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id) do
    c(client)
    |> Tesla.get(path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Start cache reserve clear.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CacheReserveClear.start(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def start(client, zone_id) do
    c(client)
    |> Tesla.post(path(zone_id), %{})
    |> handle_response()
  end

  defp path(zone_id), do: "/zones/#{zone_id}/smart_shield/cache_reserve_clear"

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
