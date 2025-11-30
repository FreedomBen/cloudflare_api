defmodule CloudflareApi.ZoneAccessShortLivedCertificateCas do
  @moduledoc ~S"""
  Manage short-lived certificate CAs for zone-level Access applications.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List all short-lived certificate CAs (`GET /zones/:zone_id/access/apps/ca`).
  """
  def list(client, zone_id) do
    c(client)
    |> Tesla.get(list_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a short-lived certificate CA for an application
  (`POST /zones/:zone_id/access/apps/:app_id/ca`).
  """
  def create(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(ca_path(zone_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a short-lived certificate CA (`GET /zones/:zone_id/access/apps/:app_id/ca`).
  """
  def get(client, zone_id, app_id) do
    c(client)
    |> Tesla.get(ca_path(zone_id, app_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a short-lived certificate CA (`DELETE /zones/:zone_id/access/apps/:app_id/ca`).
  """
  def delete(client, zone_id, app_id) do
    c(client)
    |> Tesla.delete(ca_path(zone_id, app_id), body: %{})
    |> handle_response()
  end

  defp list_path(zone_id), do: "/zones/#{zone_id}/access/apps/ca"
  defp ca_path(zone_id, app_id), do: "/zones/#{zone_id}/access/apps/#{app_id}/ca"

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
