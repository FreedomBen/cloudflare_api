defmodule CloudflareApi.RadarAs112 do
  @moduledoc ~S"""
  Radar AS112 analytics under `/radar/as112`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Summary radar as112.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAs112.summary(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def summary(client, dimension, opts \\ []) do
    get(client, with_query("/radar/as112/summary/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Timeseries radar as112.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAs112.timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries(client, opts \\ []) do
    get(client, with_query("/radar/as112/timeseries", opts))
  end

  @doc ~S"""
  Timeseries group for radar as112.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAs112.timeseries_group(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group(client, dimension, opts \\ []) do
    get(client, with_query("/radar/as112/timeseries_groups/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Top locations for radar as112.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAs112.top_locations(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_locations(client, opts \\ []) do
    get(client, with_query("/radar/as112/top/locations", opts))
  end

  @doc ~S"""
  Top locations by for radar as112.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAs112.top_locations_by(client, "dimension", "value", [])
      {:ok, %{"id" => "example"}}

  """

  def top_locations_by(client, dimension, value, opts \\ []) do
    path = "/radar/as112/top/locations/#{encode(dimension)}/#{encode(value)}"
    get(client, with_query(path, opts))
  end

  defp get(client_or_fun, url) do
    c(client_or_fun)
    |> Tesla.get(url)
    |> handle_response()
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
