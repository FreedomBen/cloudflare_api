defmodule CloudflareApi.RadarNetflows do
  @moduledoc ~S"""
  Radar NetFlows analytics under `/radar/netflows`.
  """

  @doc ~S"""
  Summary radar netflows.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarNetflows.summary(client, nil, [])
      {:ok, %{"id" => "example"}}

  """

  def summary(client, dimension \\ nil, opts \\ []) do
    path =
      if(dimension,
        do: "/radar/netflows/summary/" <> encode(dimension),
        else: "/radar/netflows/summary"
      )

    fetch(client, path, opts)
  end

  @doc ~S"""
  Timeseries radar netflows.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarNetflows.timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries(client, opts \\ []) do
    fetch(client, "/radar/netflows/timeseries", opts)
  end

  @doc ~S"""
  Timeseries group for radar netflows.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarNetflows.timeseries_group(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group(client, dimension, opts \\ []) do
    fetch(client, "/radar/netflows/timeseries_groups/" <> encode(dimension), opts)
  end

  @doc ~S"""
  Top ases for radar netflows.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarNetflows.top_ases(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_ases(client, opts \\ []) do
    fetch(client, "/radar/netflows/top/ases", opts)
  end

  @doc ~S"""
  Top locations for radar netflows.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarNetflows.top_locations(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_locations(client, opts \\ []) do
    fetch(client, "/radar/netflows/top/locations", opts)
  end

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
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
