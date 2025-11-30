defmodule CloudflareApi.RadarQuality do
  @moduledoc ~S"""
  Radar quality analytics under `/radar/quality`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Iqi summary for radar quality.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarQuality.iqi_summary(client, [])
      {:ok, %{"id" => "example"}}

  """

  def iqi_summary(client, opts \\ []) do
    fetch(client, "/radar/quality/iqi/summary", opts)
  end

  @doc ~S"""
  Iqi timeseries group for radar quality.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarQuality.iqi_timeseries_group(client, [])
      {:ok, %{"id" => "example"}}

  """

  def iqi_timeseries_group(client, opts \\ []) do
    fetch(client, "/radar/quality/iqi/timeseries_groups", opts)
  end

  @doc ~S"""
  Speed histogram for radar quality.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarQuality.speed_histogram(client, [])
      {:ok, %{"id" => "example"}}

  """

  def speed_histogram(client, opts \\ []) do
    fetch(client, "/radar/quality/speed/histogram", opts)
  end

  @doc ~S"""
  Speed summary for radar quality.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarQuality.speed_summary(client, [])
      {:ok, %{"id" => "example"}}

  """

  def speed_summary(client, opts \\ []) do
    fetch(client, "/radar/quality/speed/summary", opts)
  end

  @doc ~S"""
  Speed top ases for radar quality.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarQuality.speed_top_ases(client, [])
      {:ok, %{"id" => "example"}}

  """

  def speed_top_ases(client, opts \\ []) do
    fetch(client, "/radar/quality/speed/top/ases", opts)
  end

  @doc ~S"""
  Speed top locations for radar quality.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarQuality.speed_top_locations(client, [])
      {:ok, %{"id" => "example"}}

  """

  def speed_top_locations(client, opts \\ []) do
    fetch(client, "/radar/quality/speed/top/locations", opts)
  end

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
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
