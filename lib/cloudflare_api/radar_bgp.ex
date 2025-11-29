defmodule CloudflareApi.RadarBgp do
  @moduledoc ~S"""
  Radar BGP endpoints under `/radar/bgp`.
  """

  @doc ~S"""
  Hijacks events for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.hijacks_events(client, [])
      {:ok, %{"id" => "example"}}

  """

  def hijacks_events(client, opts \\ []) do
    get(client, with_query("/radar/bgp/hijacks/events", opts))
  end

  @doc ~S"""
  Route leak events for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.route_leak_events(client, [])
      {:ok, %{"id" => "example"}}

  """

  def route_leak_events(client, opts \\ []) do
    get(client, with_query("/radar/bgp/leaks/events", opts))
  end

  @doc ~S"""
  Ips timeseries for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.ips_timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def ips_timeseries(client, opts \\ []) do
    get(client, with_query("/radar/bgp/ips/timeseries", opts))
  end

  @doc ~S"""
  Timeseries radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries(client, opts \\ []) do
    get(client, with_query("/radar/bgp/timeseries", opts))
  end

  @doc ~S"""
  Routes asns for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.routes_asns(client, [])
      {:ok, %{"id" => "example"}}

  """

  def routes_asns(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/ases", opts))
  end

  @doc ~S"""
  Routes moas for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.routes_moas(client, [])
      {:ok, %{"id" => "example"}}

  """

  def routes_moas(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/moas", opts))
  end

  @doc ~S"""
  Routes pfx2as for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.routes_pfx2as(client, [])
      {:ok, %{"id" => "example"}}

  """

  def routes_pfx2as(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/pfx2as", opts))
  end

  @doc ~S"""
  Routes realtime for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.routes_realtime(client, [])
      {:ok, %{"id" => "example"}}

  """

  def routes_realtime(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/realtime", opts))
  end

  @doc ~S"""
  Routes stats for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.routes_stats(client, [])
      {:ok, %{"id" => "example"}}

  """

  def routes_stats(client, opts \\ []) do
    get(client, with_query("/radar/bgp/routes/stats", opts))
  end

  @doc ~S"""
  Top ases for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.top_ases(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_ases(client, opts \\ []) do
    get(client, with_query("/radar/bgp/top/ases", opts))
  end

  @doc ~S"""
  Top ases by prefixes for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.top_ases_by_prefixes(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_ases_by_prefixes(client, opts \\ []) do
    get(client, with_query("/radar/bgp/top/ases/prefixes", opts))
  end

  @doc ~S"""
  Top prefixes for radar bgp.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBgp.top_prefixes(client, [])
      {:ok, %{"id" => "example"}}

  """

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
