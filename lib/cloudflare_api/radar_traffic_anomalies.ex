defmodule CloudflareApi.RadarTrafficAnomalies do
  @moduledoc ~S"""
  Radar traffic anomaly analytics under `/radar/traffic_anomalies`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List radar traffic anomalies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarTrafficAnomalies.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    fetch(client, "/radar/traffic_anomalies", opts)
  end

  @doc ~S"""
  Top locations for radar traffic anomalies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarTrafficAnomalies.top_locations(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_locations(client, opts \\ []) do
    fetch(client, "/radar/traffic_anomalies/locations", opts)
  end

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

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
