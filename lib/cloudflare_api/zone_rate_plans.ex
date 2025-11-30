defmodule CloudflareApi.ZoneRatePlans do
  @moduledoc ~S"""
  List the available subscriptions (rate plans) for a zone.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the available rate plans (`GET /zones/:zone_id/available_rate_plans`).
  """
  def list(client, zone_id) do
    c(client)
    |> Tesla.get("/zones/#{zone_id}/available_rate_plans")
    |> handle_response()
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
