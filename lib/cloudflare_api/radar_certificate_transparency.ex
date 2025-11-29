defmodule CloudflareApi.RadarCertificateTransparency do
  @moduledoc ~S"""
  Radar certificate transparency endpoints under `/radar/ct`.
  """

  @doc ~S"""
  Authorities radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.authorities(client, [])
      {:ok, %{"id" => "example"}}

  """

  def authorities(client, opts \\ []) do
    get(client, with_query("/radar/ct/authorities", opts))
  end

  @doc ~S"""
  Authority radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.authority(client, "ca_slug", [])
      {:ok, %{"id" => "example"}}

  """

  def authority(client, ca_slug, opts \\ []) do
    get(client, with_query("/radar/ct/authorities/" <> encode(ca_slug), opts))
  end

  @doc ~S"""
  Logs radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.logs(client, [])
      {:ok, %{"id" => "example"}}

  """

  def logs(client, opts \\ []) do
    get(client, with_query("/radar/ct/logs", opts))
  end

  @doc ~S"""
  Log radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.log(client, "log_slug", [])
      {:ok, %{"id" => "example"}}

  """

  def log(client, log_slug, opts \\ []) do
    get(client, with_query("/radar/ct/logs/" <> encode(log_slug), opts))
  end

  @doc ~S"""
  Summary radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.summary(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def summary(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ct/summary/" <> encode(dimension), opts))
  end

  @doc ~S"""
  Timeseries radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.timeseries(client, [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries(client, opts \\ []) do
    get(client, with_query("/radar/ct/timeseries", opts))
  end

  @doc ~S"""
  Timeseries group for radar certificate transparency.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarCertificateTransparency.timeseries_group(client, "dimension", [])
      {:ok, %{"id" => "example"}}

  """

  def timeseries_group(client, dimension, opts \\ []) do
    get(client, with_query("/radar/ct/timeseries_groups/" <> encode(dimension), opts))
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
