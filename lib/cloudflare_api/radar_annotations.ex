defmodule CloudflareApi.RadarAnnotations do
  @moduledoc ~S"""
  Radar annotations endpoints under `/radar/annotations`.
  """

  def list(client, opts \\ []) do
    get(client, with_query("/radar/annotations", opts))
  end

  def outages(client, opts \\ []) do
    get(client, with_query("/radar/annotations/outages", opts))
  end

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
