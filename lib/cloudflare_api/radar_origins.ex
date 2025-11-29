defmodule CloudflareApi.RadarOrigins do
  @moduledoc ~S"""
  Radar origins analytics under `/radar/origins`.
  """

  def list(client, opts \\ []) do
    fetch(client, "/radar/origins", opts)
  end

  def summary(client, dimension, opts \\ []) do
    fetch(client, "/radar/origins/summary/" <> encode(dimension), opts)
  end

  def timeseries(client, opts \\ []) do
    fetch(client, "/radar/origins/timeseries", opts)
  end

  def timeseries_group(client, dimension, opts \\ []) do
    fetch(client, "/radar/origins/timeseries_groups/" <> encode(dimension), opts)
  end

  def get(client, slug, opts \\ []) do
    fetch(client, "/radar/origins/" <> encode(slug), opts)
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
