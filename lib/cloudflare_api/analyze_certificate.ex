defmodule CloudflareApi.AnalyzeCertificate do
  @moduledoc ~S"""
  Analyze SSL certificates for a zone.
  """

  @doc ~S"""
  Analyze analyze certificate.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AnalyzeCertificate.analyze(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def analyze(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/zones/#{zone_id}/ssl/analyze", params)
    |> handle_response()
  end

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
