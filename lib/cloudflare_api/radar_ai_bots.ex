defmodule CloudflareApi.RadarAiBots do
  @moduledoc ~S"""
  Radar AI Bots analytics helpers under `/radar/ai/bots`.
  """

  def summary(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ai/bots/summary/" <> encode(dimension), opts))
  end

  def summary_user_agent(client, opts \\ []) do
    get(client, with_query("/radar/ai/bots/summary/user_agent", opts))
  end

  def timeseries(client, opts \\ []) do
    get(client, with_query("/radar/ai/bots/timeseries", opts))
  end

  def timeseries_group(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ai/bots/timeseries_groups/" <> encode(dimension), opts))
  end

  def timeseries_group_user_agent(client, opts \\ []) do
    get(client, with_query("/radar/ai/bots/timeseries_groups/user_agent", opts))
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
