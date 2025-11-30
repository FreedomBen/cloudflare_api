defmodule CloudflareApi.DnsSettings do
  @moduledoc ~S"""
  DNS settings helpers for accounts and zones.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Show DNS settings for a zone (`GET /zones/:zone_id/dns_settings`).
  """
  def zone_settings(client, zone_id) do
    request(client, :get, "/zones/#{zone_id}/dns_settings")
  end

  @doc ~S"""
  Update DNS settings for a zone (`PATCH /zones/:zone_id/dns_settings`).
  """
  def update_zone_settings(client, zone_id, params) when is_map(params) do
    request(client, :patch, "/zones/#{zone_id}/dns_settings", params)
  end

  @doc ~S"""
  Show DNS settings for an account (`GET /accounts/:account_id/dns_settings`).
  """
  def account_settings(client, account_id) do
    request(client, :get, "/accounts/#{account_id}/dns_settings")
  end

  @doc ~S"""
  Update DNS settings for an account (`PATCH /accounts/:account_id/dns_settings`).
  """
  def update_account_settings(client, account_id, params) when is_map(params) do
    request(client, :patch, "/accounts/#{account_id}/dns_settings", params)
  end

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
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
