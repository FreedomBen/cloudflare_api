defmodule CloudflareApi.RadarDomainsRanking do
  @moduledoc ~S"""
  Radar domain ranking endpoints under `/radar/ranking`.
  """

  def top_domains(client, opts \\ []) do
    fetch(client, "/radar/ranking/top", opts)
  end

  def timeseries_groups(client, opts \\ []) do
    fetch(client, "/radar/ranking/timeseries_groups", opts)
  end

  def domain_details(client, domain, opts \\ []) do
    fetch(client, "/radar/ranking/domain/" <> encode(domain), opts)
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
