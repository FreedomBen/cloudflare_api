defmodule CloudflareApi.RadarHttp do
  @moduledoc ~S"""
  Radar HTTP analytics under `/radar/http`.
  """

  def summary(client, dimension, opts \\ []) do
    fetch(client, "/radar/http/summary/" <> encode(dimension), opts)
  end

  def timeseries(client, opts \\ []) do
    fetch(client, "/radar/http/timeseries", opts)
  end

  def timeseries_group(client, dimension, opts \\ []) do
    fetch(client, "/radar/http/timeseries_groups/" <> encode(dimension), opts)
  end

  def top_ases(client, opts \\ []) do
    fetch(client, "/radar/http/top/ases", opts)
  end

  def top_ases_by(client, dimension, value, opts \\ []) do
    path = "/radar/http/top/ases/#{encode(dimension)}/#{encode(value)}"
    fetch(client, path, opts)
  end

  def top_locations(client, opts \\ []) do
    fetch(client, "/radar/http/top/locations", opts)
  end

  def top_locations_by(client, dimension, value, opts \\ []) do
    path = "/radar/http/top/locations/#{encode(dimension)}/#{encode(value)}"
    fetch(client, path, opts)
  end

  def top_browsers(client, opts \\ []) do
    fetch(client, "/radar/http/top/browser", opts)
  end

  def top_browser_families(client, opts \\ []) do
    fetch(client, "/radar/http/top/browser_family", opts)
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
