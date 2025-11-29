defmodule CloudflareApi.RadarBgp do
  @moduledoc ~S"""
  Radar BGP endpoints under `/radar/bgp`.
  """

  def hijacks_events(client, opts \\ []) do
    get(client, with_query("/radar/bgp/hijacks/events", opts))
  end

  def route_leak_events(client, opts \\ []) do
    get(client, with_query("/radar/bgp/leaks/events", opts))
  end

  def ips_timeseries(client, opts \\ []) do
    get(client, with_query("/radar/bgp/ips/timeseries", opts))
  end

  def timeseries(client, opts \\ []) do
    get(client, with_query("/radar/bgp/timeseries", opts))
  end

  def routes_asns(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/ases", opts))
  end

  def routes_moas(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/moas", opts))
  end

  def routes_pfx2as(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/pfx2as", opts))
  end

  def routes_realtime(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/realtime", opts))
  end

  def routes_stats(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/stats", opts))
  end

  def top_ases(client, opts \\ []) do
    get(client, with_query("/radar/bgp/top/ases", opts))
  end

  def top_ases_by_prefixes(client, opts \\ []) do
    get(client, with_query("/radar/bgp/top/ases/prefixes", opts))
  end

  def top_prefixes(client, opts \\ []) do
    get(client, with_query("/radar/bgp/top/prefixes", opts))
  end

  defp get(client_or_fun, url) do
    c(client_or_fun)
    |> Tesla.get(url)
    |> handle_response()
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
