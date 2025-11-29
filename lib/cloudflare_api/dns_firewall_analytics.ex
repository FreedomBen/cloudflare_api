defmodule CloudflareApi.DnsFirewallAnalytics do
  @moduledoc ~S"""
  DNS Firewall analytics helpers for `/dns_analytics/report` and `/bytime`.
  """

  def report(client, account_id, cluster_id, opts \\ []) do
    get(client, analytics_path(account_id, cluster_id) <> query_suffix(opts))
  end

  def report_by_time(client, account_id, cluster_id, opts \\ []) do
    get(
      client,
      analytics_path(account_id, cluster_id) <> "/bytime" <> query_suffix(opts)
    )
  end

  defp analytics_path(account_id, cluster_id) do
    "/accounts/#{account_id}/dns_firewall/#{cluster_id}/dns_analytics/report"
  end

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp get(client, url) do
    c(client)
    |> Tesla.get(url)
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
