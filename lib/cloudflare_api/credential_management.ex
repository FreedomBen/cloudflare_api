defmodule CloudflareApi.CredentialManagement do
  @moduledoc ~S"""
  Store credentials for R2 catalog buckets.
  """

  @doc ~S"""
  Store credential management.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CredentialManagement.store(client, "account_id", "bucket_name", %{})
      {:ok, %{"id" => "example"}}

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
