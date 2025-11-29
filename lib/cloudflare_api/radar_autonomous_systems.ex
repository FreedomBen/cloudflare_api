defmodule CloudflareApi.RadarAutonomousSystems do
  @moduledoc ~S"""
  Radar autonomous systems endpoints under `/radar/entities/asns`.
  """

  def list(client, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns", opts))
  end

  def get_by_ip(client, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/ip", opts))
  end

  def get(client, asn, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/" <> encode(asn), opts))
  end

  def as_set(client, asn, opts \\ []) do
    fetch(client, with_query("/radar/entities/asns/#{encode(asn)}/as_set", opts))
  end

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
