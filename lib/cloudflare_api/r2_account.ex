defmodule CloudflareApi.R2Account do
  @moduledoc ~S"""
  Fetch account-level R2 metrics (`GET /accounts/:account_id/r2/metrics`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Retrieve metrics for an account's R2 usage.
  """
  def metrics(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(path(account_id), opts))
    |> handle_response()
  end

  defp path(account_id), do: "/accounts/#{account_id}/r2/metrics"

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
