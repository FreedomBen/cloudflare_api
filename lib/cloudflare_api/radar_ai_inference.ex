defmodule CloudflareApi.RadarAiInference do
  @moduledoc ~S"""
  Radar AI inference analytics under `/radar/ai/inference`.
  """

  def summary(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ai/inference/summary/" <> encode(dimension), opts))
  end

  def summary_by_model(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/summary/model", opts))
  end

  def summary_by_task(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/summary/task", opts))
  end

  def timeseries_group(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ai/inference/timeseries_groups/" <> encode(dimension), opts))
  end

  def timeseries_group_model(client, opts \\ []) do
    get(client, with_query("/radar/ai/inference/timeseries_groups/model", opts))
  end

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
