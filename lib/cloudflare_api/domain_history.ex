defmodule CloudflareApi.DomainHistory do
  @moduledoc ~S"""
  Cloudforce One domain history helpers (`/accounts/:account_id/intel/domain-history`).
  """

  def get(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/intel/domain-history" <> query_suffix(opts))
    |> handle()
  end

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
