defmodule CloudflareApi.RadarBots do
  @moduledoc ~S"""
  Radar bot analytics endpoints under `/radar/bots`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Overview radar bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBots.overview(client, [])
      {:ok, %{"id" => "example"}}

  """

  def overview(client, opts \\ []) do
    get(client, with_query("/radar/bots", opts))
  end

  @doc ~S"""
  Summary radar bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBots.summary(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def summary(client, dimension, opts \\ []) do
    get(client, with_query("/radar/bots/summary/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Timeseries radar bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBots.timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries(client, opts \\ []) do
    get(client, with_query("/radar/bots/timeseries", opts))
  end

  @doc ~S"""
  Timeseries group for radar bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBots.timeseries_group(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group(client, dimension, opts \\ []) do
    get(client, with_query("/radar/bots/timeseries_groups/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Get bot for radar bots.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarBots.get_bot(client, "bot_slug", [])
      {:ok, %{"id" => "example"}}

  """

  def get_bot(client, bot_slug, opts \\ []) do
    get(client, with_query("/radar/bots/" <> encode(bot_slug), opts))
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
