defmodule CloudflareApi.CacheReserveClear do
  @moduledoc ~S"""
  Inspect and trigger Smart Shield Cache Reserve Clear jobs for a zone.
  """

  def get(client, zone_id) do
    c(client)
    |> Tesla.get(path(zone_id))
    |> handle_response()
  end

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
