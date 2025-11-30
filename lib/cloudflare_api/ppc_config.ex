defmodule CloudflareApi.PpcConfig do
  @moduledoc ~S"""
  Manage Pay-Per-Crawl configuration for zones and account eligibility data.

  These helpers cover the `/pay-per-crawl` endpoints that control per-zone
  configuration and the `zones_can_be_enabled` account flag list.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the Pay-Per-Crawl configuration for a zone (`GET /zones/:zone_id/pay-per-crawl/configuration`).

  Returns the configuration map on success.
  """
  def get_config(client, zone_id) do
    request(client, :get, zone_config_path(zone_id))
  end

  @doc ~S"""
  Create an initial Pay-Per-Crawl configuration for a zone (`POST /zones/:zone_id/pay-per-crawl/configuration`).

  Pass a map that matches the `pay-per-crawl_DaricConfig` schema (for example `%{"enabled" => true}`).
  """
  def create_config(client, zone_id, params) when is_map(params) do
    request(client, :post, zone_config_path(zone_id), params)
  end

  @doc ~S"""
  Update an existing Pay-Per-Crawl configuration (`PATCH /zones/:zone_id/pay-per-crawl/configuration`).

  Accepts the same payload as `create_config/3`.
  """
  def patch_config(client, zone_id, params) when is_map(params) do
    request(client, :patch, zone_config_path(zone_id), params)
  end

  @doc ~S"""
  Query the current `can_be_enabled` values for zones under an account (`POST /accounts/:account_id/pay-per-crawl/zones_can_be_enabled/query`).

  Provide a payload like `%{"zones" => [%{"id" => "zone-id"}]}` and the endpoint responds with the same shape plus `can_be_enabled`.
  """
  def query_zones_can_be_enabled(client, account_id, payload) when is_map(payload) do
    request(client, :post, zones_query_path(account_id), payload)
  end

  @doc ~S"""
  Set the `can_be_enabled` flag for multiple zones (`PATCH /accounts/:account_id/pay-per-crawl/zones_can_be_enabled`).

  Each entry in the payload should include the zone `id` and the desired `can_be_enabled` boolean.
  """
  def set_zones_can_be_enabled(client, account_id, payload) when is_map(payload) do
    request(client, :patch, zones_path(account_id), payload)
  end

  defp zone_config_path(zone_id),
    do: "/zones/#{zone_id}/pay-per-crawl/configuration"

  defp zones_path(account_id),
    do: "/accounts/#{account_id}/pay-per-crawl/zones_can_be_enabled"

  defp zones_query_path(account_id), do: zones_path(account_id) <> "/query"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
        :post -> Tesla.post(client, url, body || %{})
        :patch -> Tesla.patch(client, url, body || %{})
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299 and is_map(body),
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
