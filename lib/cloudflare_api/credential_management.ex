defmodule CloudflareApi.CredentialManagement do
  @moduledoc ~S"""
  Store credentials for R2 catalog buckets.
  """

  def store(client, account_id, bucket_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(path(account_id, bucket_name), params)
    |> handle_response()
  end

  defp path(account_id, bucket_name),
    do: "/accounts/#{account_id}/r2-catalog/#{bucket_name}/credential"

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
