defmodule CloudflareApi.RadarAnnotations do
  @moduledoc ~S"""
  Radar annotations endpoints under `/radar/annotations`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List radar annotations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAnnotations.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    get(client, with_query("/radar/annotations", opts))
  end

  @doc ~S"""
  Outages radar annotations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAnnotations.outages(client, [])
      {:ok, %{"id" => "example"}}

  """

  def outages(client, opts \\ []) do
    get(client, with_query("/radar/annotations/outages", opts))
  end

  @doc ~S"""
  Outage locations for radar annotations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAnnotations.outage_locations(client, [])
      {:ok, %{"id" => "example"}}

  """

  def outage_locations(client, opts \\ []) do
    get(client, with_query("/radar/annotations/outages/locations", opts))
  end

  defp get(client_or_fun, url) do
    c(client_or_fun)
    |> Tesla.get(url)
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
