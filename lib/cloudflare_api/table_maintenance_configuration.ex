defmodule CloudflareApi.TableMaintenanceConfiguration do
  @moduledoc ~S"""
  Manage R2 catalog table maintenance configs under
  `/accounts/:account_id/r2-catalog/:bucket/namespaces/:namespace/tables/:table/maintenance-configs`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch maintenance configuration (`GET /maintenance-configs`).
  """
  def get(client, account_id, bucket, namespace, table, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(path(account_id, bucket, namespace, table), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update maintenance configuration (`POST /maintenance-configs`).
  """
  def update(client, account_id, bucket, namespace, table, params) when is_map(params) do
    c(client)
    |> Tesla.post(path(account_id, bucket, namespace, table), params)
    |> handle_response()
  end

  defp path(account_id, bucket, namespace, table) do
    "/accounts/#{account_id}/r2-catalog/#{bucket}/namespaces/#{namespace}/tables/#{table}/maintenance-configs"
  end

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
