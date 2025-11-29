defmodule CloudflareApi.RadarAiInference do
  @moduledoc ~S"""
  Radar AI inference analytics under `/radar/ai/inference`.
  """

  @doc ~S"""
  Summary radar ai inference.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAiInference.summary(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def summary(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ai/inference/summary/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Summary by model for radar ai inference.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAiInference.summary_by_model(client, [])
      {:ok, %{"id" => "example"}}

  """

  def summary_by_model(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/summary/model", opts))
  end

  @doc ~S"""
  Summary by task for radar ai inference.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAiInference.summary_by_task(client, [])
      {:ok, %{"id" => "example"}}

  """

  def summary_by_task(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/summary/task", opts))
  end

  @doc ~S"""
  Timeseries group for radar ai inference.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAiInference.timeseries_group(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ai/inference/timeseries_groups/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Timeseries group model for radar ai inference.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAiInference.timeseries_group_model(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group_model(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/timeseries_groups/model", opts))
  end

  @doc ~S"""
  Timeseries group task for radar ai inference.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAiInference.timeseries_group_task(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group_task(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/timeseries_groups/task", opts))
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
