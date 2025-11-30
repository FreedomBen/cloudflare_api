defmodule CloudflareApi.Zones do
  @moduledoc ~S"""
  Thin wrapper around `GET/POST/DELETE/PATCH` zone endpoints plus activation
  checks and cache purges. For struct helpers, see `CloudflareApi.Zone`.
  """

  use CloudflareApi.Typespecs

  @doc """
  List zones visible to the authenticated account (`GET /zones`).
  """
  def list(client, opts \\ [])

  def list(client, nil), do: list(client, [])

  def list(client, opts) do
    c(client)
    |> Tesla.get(with_query("/zones", opts))
    |> handle_response()
  end

  @doc """
  Create a zone (`POST /zones`).
  """
  def create(client, params) when is_map(params) do
    c(client)
    |> Tesla.post("/zones", params)
    |> handle_response()
  end

  @doc """
  Delete a zone (`DELETE /zones/:zone_id`).
  """
  def delete(client, zone_id) do
    c(client)
    |> Tesla.delete(zone_path(zone_id), body: %{})
    |> handle_response()
  end

  @doc """
  Fetch a zone (`GET /zones/:zone_id`).
  """
  def get(client, zone_id) do
    c(client)
    |> Tesla.get(zone_path(zone_id))
    |> handle_response()
  end

  @doc """
  Patch a zone (`PATCH /zones/:zone_id`).
  """
  def patch(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(zone_path(zone_id), params)
    |> handle_response()
  end

  @doc """
  Trigger an activation check (`PUT /zones/:zone_id/activation_check`).
  """
  def activation_check(client, zone_id) do
    c(client)
    |> Tesla.put(zone_path(zone_id) <> "/activation_check", %{})
    |> handle_response()
  end

  @doc """
  Purge cache (`POST /zones/:zone_id/purge_cache`).
  """
  def purge_cache(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(zone_path(zone_id) <> "/purge_cache", params)
    |> handle_response()
  end

  defp zone_path(zone_id), do: "/zones/#{URI.encode_www_form(to_string(zone_id))}"

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errs}}}), do: {:error, errs}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
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
