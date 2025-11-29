defmodule CloudflareApi.ZoneHolds do
  @moduledoc ~S"""
  Manage zone holds (`/zones/:zone_id/hold`).
  """

  @doc """
  Get hold status (`GET /zones/:zone_id/hold`).
  """
  def get(client, zone_id) do
    c(client)
    |> Tesla.get(path(zone_id))
    |> handle_response()
  end

  @doc """
  Create a hold (`POST /zones/:zone_id/hold`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(path(zone_id), params)
    |> handle_response()
  end

  @doc """
  Delete a hold (`DELETE /zones/:zone_id/hold`).
  """
  def delete(client, zone_id, params \\ %{}) do
    c(client)
    |> Tesla.delete(path(zone_id), body: params)
    |> handle_response()
  end

  @doc """
  Patch a hold (`PATCH /zones/:zone_id/hold`).
  """
  def patch(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(path(zone_id), params)
    |> handle_response()
  end

  defp path(zone_id), do: "/zones/#{zone_id}/hold"

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
