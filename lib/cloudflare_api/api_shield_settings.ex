defmodule CloudflareApi.ApiShieldSettings do
  @moduledoc ~S"""
  Manage API Shield configuration properties at the zone level.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Retrieve settings (`GET /api_gateway/configuration`).
  """
  def get_configuration(client, zone_id) do
    c(client)
    |> Tesla.get(config_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Set configuration properties via `PUT`.
  """
  def update_configuration(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(config_path(zone_id), params)
    |> handle_response()
  end

  defp config_path(zone_id), do: "/zones/#{zone_id}/api_gateway/configuration"

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
