defmodule CloudflareApi.DlsRegionalServices do
  @moduledoc ~S"""
  Regional Services helpers wrapping the `/addressing/regional_hostnames`
  account/zone endpoints (DLS Regional Services tag).
  """

  @doc ~S"""
  List available regions (`GET /accounts/:account_id/addressing/regional_hostnames/regions`).
  """
  def list_regions(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/addressing/regional_hostnames/regions")
    |> handle_response()
  end

  @doc ~S"""
  List regional hostnames for a zone (`GET /zones/:zone_id/addressing/regional_hostnames`).
  """
  def list_hostnames(client, zone_id) do
    c(client)
    |> Tesla.get(zone_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a regional hostname (`POST /zones/:zone_id/addressing/regional_hostnames`).
  """
  def create_hostname(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(zone_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a specific hostname (`GET /zones/:zone_id/addressing/regional_hostnames/:hostname`).
  """
  def get_hostname(client, zone_id, hostname) do
    c(client)
    |> Tesla.get(hostname_path(zone_id, hostname))
    |> handle_response()
  end

  @doc ~S"""
  Update a hostname (`PATCH /zones/:zone_id/addressing/regional_hostnames/:hostname`).
  """
  def update_hostname(client, zone_id, hostname, params) when is_map(params) do
    c(client)
    |> Tesla.patch(hostname_path(zone_id, hostname), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a hostname (`DELETE /zones/:zone_id/addressing/regional_hostnames/:hostname`).
  """
  def delete_hostname(client, zone_id, hostname) do
    c(client)
    |> Tesla.delete(hostname_path(zone_id, hostname), body: %{})
    |> handle_response()
  end

  defp zone_path(zone_id), do: "/zones/#{zone_id}/addressing/regional_hostnames"
  defp hostname_path(zone_id, hostname), do: zone_path(zone_id) <> "/#{hostname}"

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
