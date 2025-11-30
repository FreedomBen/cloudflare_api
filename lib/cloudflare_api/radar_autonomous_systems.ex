defmodule CloudflareApi.RadarAutonomousSystems do
  @moduledoc ~S"""
  Radar autonomous systems endpoints under `/radar/entities/asns`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List radar autonomous systems.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAutonomousSystems.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns", opts))
  end

  @doc ~S"""
  Get by ip for radar autonomous systems.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAutonomousSystems.get_by_ip(client, [])
      {:ok, %{"id" => "example"}}

  """

  def get_by_ip(client, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/ip", opts))
  end

  @doc ~S"""
  Get radar autonomous systems.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAutonomousSystems.get(client, "asn", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, asn, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/" <> encode(asn), opts))
  end

  @doc ~S"""
  As set for radar autonomous systems.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAutonomousSystems.as_set(client, "asn", [])
      {:ok, %{"id" => "example"}}

  """

  def as_set(client, asn, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/#{encode(asn)}/as_set", opts))
  end

  @doc ~S"""
  Relationships radar autonomous systems.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RadarAutonomousSystems.relationships(client, "asn", [])
      {:ok, %{"id" => "example"}}

  """

  def relationships(client, asn, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/#{encode(asn)}/rel", opts))
  end

  defp fetch(client_or_fun, url) do
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
