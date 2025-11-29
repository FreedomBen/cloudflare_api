defmodule CloudflareApi.DnsAnalytics do
  @moduledoc ~S"""
  DNS analytics helpers wrapping `/zones/:zone_id/dns_analytics`.
  """

  @doc ~S"""
  Retrieve DNS analytics table data (`GET /zones/:zone_id/dns_analytics/report`).
  """
  def report(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(report_path(zone_id) <> query_suffix(opts))
    |> handle_response()
  end

  @doc ~S"""
  Retrieve DNS analytics by time (`GET /zones/:zone_id/dns_analytics/report/bytime`).
  """
  def report_by_time(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(report_path(zone_id) <> "/bytime" <> query_suffix(opts))
    |> handle_response()
  end

  defp report_path(zone_id), do: "/zones/#{zone_id}/dns_analytics/report"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
