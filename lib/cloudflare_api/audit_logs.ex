defmodule CloudflareApi.AuditLogs do
  @moduledoc ~S"""
  Fetch audit logs at account or user scope.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List account for audit logs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AuditLogs.list_account(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_account(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/audit_logs", opts)
  end

  @doc ~S"""
  List account v2 for audit logs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AuditLogs.list_account_v2(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_account_v2(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/logs/audit", opts)
  end

  @doc ~S"""
  List user for audit logs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AuditLogs.list_user(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_user(client, opts \\ []) do
    request(client, "/user/audit_logs", opts)
  end

  defp request(client, path, opts) do
    url =
      case opts do
        [] -> path
        _ -> path <> "?" <> CloudflareApi.uri_encode_opts(opts)
      end

    c(client)
    |> Tesla.get(url)
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
