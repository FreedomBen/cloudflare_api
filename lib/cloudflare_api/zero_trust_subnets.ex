defmodule CloudflareApi.ZeroTrustSubnets do
  @moduledoc ~S"""
  Zero Trust subnet helpers (`/accounts/:account_id/zerotrust/subnets`).
  """

  @doc """
  List subnets (`GET /accounts/:account_id/zerotrust/subnets`).

  Supports filters such as `:name`, `:network`, `:per_page`, etc.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  Update the Cloudflare source subnet for an address family (`PATCH .../cloudflare_source/:address_family`).
  """
  def update_cloudflare_source(client, account_id, address_family, params) when is_map(params) do
    c(client)
    |> Tesla.patch(
      cloudflare_source_path(account_id, address_family),
      params
    )
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/zerotrust/subnets"

  defp cloudflare_source_path(account_id, address_family),
    do: base_path(account_id) <> "/cloudflare_source/#{encode(address_family)}"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
