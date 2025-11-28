defmodule CloudflareApi.Zones do
  @moduledoc ~S"""
  Lightweight wrapper around Cloudflare zone listing.

  This module currently exposes a single `list/2` function that maps directly
  to `GET /zones` and returns the raw zone maps from Cloudflare. For a richer
  struct representation, see `CloudflareApi.Zone`.
  """

  @doc ~S"""
  List zones visible to the authenticated account.

  - `client` – a `Tesla.Client.t()` or a zero-arity function returning one
  - `opts` – optional keyword list of query parameters as defined by the
    Cloudflare API (`name`, `status`, `"account.id"`, `"account.name"`, `page`,
    `per_page`, etc.)

  On success, returns `{:ok, zones}` where `zones` is the raw `"result"` list
  from Cloudflare. If Cloudflare responds with an `errors` list, returns
  `{:error, errors}`; other failures are wrapped as `{:error, err}`.
  """
  def list(client, opts \\ nil) do
    case Tesla.get(c(client), list_url(opts)) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  defp list_url(opts) do
    case opts do
      nil -> "/zones"
      _ -> "/zones?#{CloudflareApi.uri_encode_opts(opts)}"
    end
  end

  defp c(%Tesla.Client{} = client), do: client
  defp c(client), do: client.()
end

# HTTP
# |> auth("Bearer <token>")
# |> headers(accept: "application/json")
# |> headers("content-type":, "application/json")
# |> get("https://example.con/api/v1/hello?name=bob")

# cf = CloudflareApi.client(token)
# ClouflareApi.list_dns_records(cf)
#
#
# CloudflareApi.client(token)
# |> ClouflareApi.DnsRecords.list()
# |> Enum.map(fn a -> a end)
