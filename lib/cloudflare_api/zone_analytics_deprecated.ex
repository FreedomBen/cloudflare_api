defmodule CloudflareApi.ZoneAnalyticsDeprecated do
  @moduledoc ~S"""
  Access the deprecated zone analytics dashboard and colo endpoints.
  """

  use CloudflareApi.Typespecs

  @doc """
  Fetch analytics dashboard (`GET /zones/:zone_id/analytics/dashboard`).
  """
  def get_dashboard(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(path(zone_id, "/analytics/dashboard"), opts))
    |> handle_response()
  end

  @doc """
  Fetch colo analytics (`GET /zones/:zone_id/analytics/colos`).
  """
  def get_colos(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(path(zone_id, "/analytics/colos"), opts))
    |> handle_response()
  end

  defp path(zone_id, suffix), do: "/zones/#{zone_id}#{suffix}"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errs}}}), do: {:error, errs}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
