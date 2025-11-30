defmodule CloudflareApi.OriginPostQuantum do
  @moduledoc ~S"""
  Manage the Origin Post-Quantum encryption zone setting
  (`/zones/:zone_id/cache/origin_post_quantum_encryption`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Retrieve the setting (`GET /origin_post_quantum_encryption`).
  """
  def get(client, zone_id) do
    c(client)
    |> Tesla.get(path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update the setting (`PUT /origin_post_quantum_encryption`).
  """
  def update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(path(zone_id), params)
    |> handle_response()
  end

  defp path(zone_id), do: "/zones/#{zone_id}/cache/origin_post_quantum_encryption"

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
