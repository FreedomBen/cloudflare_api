defmodule CloudflareApi.PassiveDnsByIp do
  @moduledoc ~S"""
  Look up passive DNS records for an IP via
  `GET /accounts/:account_id/intel/dns`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch passive DNS data for an account.

  Optional query parameters such as `ip` or pagination values can be passed via
  `opts`.
  """
  def get(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/intel/dns"

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
