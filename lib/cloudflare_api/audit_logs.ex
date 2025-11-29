defmodule CloudflareApi.AuditLogs do
  @moduledoc ~S"""
  Fetch audit logs at account or user scope.
  """

  def list_account(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/audit_logs", opts)
  end

  def list_account_v2(client, account_id, opts \\ []) do
    request(client, "/accounts/#{account_id}/logs/audit", opts)
  end

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
