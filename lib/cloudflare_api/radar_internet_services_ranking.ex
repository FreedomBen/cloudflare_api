defmodule CloudflareApi.RadarInternetServicesRanking do
  @moduledoc ~S"""
  Radar internet services ranking endpoints under `/radar/ranking/internet_services`.
  """

  @doc ~S"""
  Categories radar internet services ranking.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarInternetServicesRanking.categories(client, [])
      {:ok, %{"id" => "example"}}

  """

  def categories(client, opts \\ []) do
    fetch(client, "/radar/ranking/internet_services/categories", opts)
  end

  @doc ~S"""
  Top radar internet services ranking.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarInternetServicesRanking.top(client, [])
      {:ok, %{"id" => "example"}}

  """

  def top(client, opts \\ []) do
    fetch(client, "/radar/ranking/internet_services/top", opts)
  end

  @doc ~S"""
  Timeseries groups for radar internet services ranking.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarInternetServicesRanking.timeseries_groups(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_groups(client, opts \\ []) do
    fetch(client, "/radar/ranking/internet_services/timeseries_groups", opts)
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
