defmodule CloudflareApi.RadarLayer7Attacks do
  @moduledoc ~S"""
  Radar Layer 7 attack analytics under `/radar/attacks/layer7`.
  """

  @doc ~S"""
  Summary radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.summary(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def summary(client, dimension, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/summary/" <> encode(dimension), opts)
  end

  @doc ~S"""
  Timeseries radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/timeseries", opts)
  end

  @doc ~S"""
  Timeseries group for radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.timeseries_group(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group(client, dimension, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/timeseries_groups/" <> encode(dimension), opts)
  end

  @doc ~S"""
  Top attacks for radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.top_attacks(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_attacks(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/attacks", opts)
  end

  @doc ~S"""
  Top ases origin for radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.top_ases_origin(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_ases_origin(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/ases/origin", opts)
  end

  @doc ~S"""
  Top locations for radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.top_locations(client, :origin, [])
      {:ok, %{"id" => "example"}}

  """

  def top_locations(client, type, opts \\ []) when type in [:origin, :target] do
    fetch(client, "/radar/attacks/layer7/top/locations/" <> to_string(type), opts)
  end

  @doc ~S"""
  Top verticals for radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.top_verticals(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_verticals(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/vertical", opts)
  end

  @doc ~S"""
  Top industries for radar layer7 attacks.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarLayer7Attacks.top_industries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_industries(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/industry", opts)
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
