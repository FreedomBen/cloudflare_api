defmodule CloudflareApi.ArgoAnalyticsZone do
  @moduledoc ~S"""
  Fetch Argo analytics for a zone.
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(url(zone_id, opts))
    |> handle_response()
  end

  defp url(zone_id, []), do: base_path(zone_id)

  defp url(zone_id, opts) do
    base_path(zone_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/analytics/latency"

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
