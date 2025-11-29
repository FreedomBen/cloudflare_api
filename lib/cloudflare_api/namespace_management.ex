defmodule CloudflareApi.NamespaceManagement do
  @moduledoc ~S"""
  List R2 catalog namespaces (`/accounts/:account_id/r2-catalog/:bucket_name/namespaces`).
  """

  def list(client, account_id, bucket_name, opts \\ []) do
    c(client)
    |> Tesla.get(base(account_id, bucket_name) <> query(opts))
    |> handle_response()
  end

  defp base(account_id, bucket_name),
    do: "/accounts/#{account_id}/r2-catalog/#{bucket_name}/namespaces"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
