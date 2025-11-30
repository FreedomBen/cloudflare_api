defmodule CloudflareApi.SmartTieredCache do
  @moduledoc ~S"""
  Manage Smart Tiered Cache settings at `/zones/:zone_id/cache/tiered_cache_smart_topology_enable`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the Smart Tiered Cache configuration (`GET /cache/tiered_cache_smart_topology_enable`).
  """
  def get(client, zone_id) do
    c(client)
    |> Tesla.get(path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update Smart Tiered Cache (`PATCH /cache/tiered_cache_smart_topology_enable`).
  """
  def update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete the Smart Tiered Cache override (`DELETE /cache/tiered_cache_smart_topology_enable`).
  """
  def delete(client, zone_id) do
    c(client)
    |> Tesla.delete(path(zone_id), body: %{})
    |> handle_response()
  end

  defp path(zone_id), do: "/zones/#{zone_id}/cache/tiered_cache_smart_topology_enable"

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
