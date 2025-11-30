defmodule CloudflareApi.IpIntelligence do
  @moduledoc ~S"""
  IP intelligence overview helper (`/accounts/:account_id/intel/ip`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Get overview for ip intelligence.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpIntelligence.get_overview(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_overview(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/intel/ip" <> query_suffix(opts))
  end

  defp request(client, url) do
    c(client)
    |> Tesla.get(url)
    |> handle_response()
  end

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
