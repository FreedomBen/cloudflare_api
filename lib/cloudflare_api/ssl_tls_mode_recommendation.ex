defmodule CloudflareApi.SslTlsModeRecommendation do
  @moduledoc ~S"""
  Fetch SSL/TLS mode recommendation (`GET /zones/:zone_id/ssl/recommendation`).
  """

  @doc ~S"""
  Recommendation ssl tls mode recommendation.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SslTlsModeRecommendation.recommendation(client, "zone_id", [])
      {:ok, %{"id" => "example"}}

  """

  def recommendation(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/zones/#{zone_id}/ssl/recommendation", opts))
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
