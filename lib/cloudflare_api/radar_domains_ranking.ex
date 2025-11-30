defmodule CloudflareApi.RadarDomainsRanking do
  @moduledoc ~S"""
  Radar domain ranking endpoints under `/radar/ranking`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Top domains for radar domains ranking.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarDomainsRanking.top_domains(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top_domains(client, opts \\ []) do
    fetch(client, "/radar/ranking/top", opts)
  end

  @doc ~S"""
  Timeseries groups for radar domains ranking.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarDomainsRanking.timeseries_groups(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_groups(client, opts \\ []) do
    fetch(client, "/radar/ranking/timeseries_groups", opts)
  end

  @doc ~S"""
  Domain details for radar domains ranking.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarDomainsRanking.domain_details(client, "domain", [])
      {:ok, %{"id" => "example"}}

  """

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
