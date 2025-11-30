defmodule CloudflareApi.ZoneZeroTrustOrganization do
  @moduledoc ~S"""
  Manage the Zero Trust organization configured at the zone scope.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the Zero Trust organization for a zone (`GET /zones/:zone_id/access/organizations`).
  """
  def get(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a Zero Trust organization for a zone (`POST /zones/:zone_id/access/organizations`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update the zone Zero Trust organization (`PUT /zones/:zone_id/access/organizations`).
  """
  def update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Revoke all access tokens for a user (`POST /zones/:zone_id/access/organizations/revoke_user`).
  """
  def revoke_user(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(revoke_path(zone_id), params)
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/access/organizations"
  defp revoke_path(zone_id), do: base_path(zone_id) <> "/revoke_user"

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
