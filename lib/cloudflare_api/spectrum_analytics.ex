defmodule CloudflareApi.SpectrumAnalytics do
  @moduledoc ~S"""
  Wrap Spectrum analytics endpoints under `/zones/:zone_id/spectrum/analytics`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch current aggregate metrics (`GET /aggregate/current`).
  """
  def aggregate_current(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id) <> "/aggregate/current", opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch analytics grouped by time (`GET /events/bytime`).
  """
  def events_by_time(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id) <> "/events/bytime", opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch analytics summary (`GET /events/summary`).
  """
  def events_summary(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id) <> "/events/summary", opts))
    |> handle_response()
  end

  defp base(zone_id), do: "/zones/#{zone_id}/spectrum/analytics"

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
