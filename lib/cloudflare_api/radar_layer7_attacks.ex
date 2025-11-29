defmodule CloudflareApi.RadarLayer7Attacks do
  @moduledoc ~S"""
  Radar Layer 7 attack analytics under `/radar/attacks/layer7`.
  """

  def summary(client, dimension, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/summary/" <> encode(dimension), opts)
  end

  def timeseries(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/timeseries", opts)
  end

  def timeseries_group(client, dimension, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/timeseries_groups/" <> encode(dimension), opts)
  end

  def top_attacks(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/attacks", opts)
  end

  def top_ases_origin(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/ases/origin", opts)
  end

  def top_locations(client, type, opts \\ []) when type in [:origin, :target] do
    fetch(client, "/radar/attacks/layer7/top/locations/" <> to_string(type), opts)
  end

  def top_verticals(client, opts \\ []) do
    fetch(client, "/radar/attacks/layer7/top/vertical", opts)
  end

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
