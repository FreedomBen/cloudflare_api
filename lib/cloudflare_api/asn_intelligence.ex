defmodule CloudflareApi.AsnIntelligence do
  @moduledoc ~S"""
  Wraps Cloudflare ASN Intelligence endpoints for a given account.

  Functions return `{:ok, result}` or `{:error, errors}` consistent with the
  rest of the library.
  """

  @doc ~S"""
  Retrieve ASN overview information (`GET /intel/asn/:asn`).
  """
  def get_overview(client, account_id, asn) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/intel/asn/#{asn}")
    |> handle_response()
  end

  @doc ~S"""
  List subnets associated with an ASN. Accepts optional filters via `opts`.
  """
  def list_subnets(client, account_id, asn, opts \\ []) do
    c(client)
    |> Tesla.get(subnet_url(account_id, asn, opts))
    |> handle_response()
  end

  defp subnet_url(account_id, asn, []), do: "/accounts/#{account_id}/intel/asn/#{asn}/subnets"

  defp subnet_url(account_id, asn, opts) do
    "/accounts/#{account_id}/intel/asn/#{asn}/subnets?" <> CloudflareApi.uri_encode_opts(opts)
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
