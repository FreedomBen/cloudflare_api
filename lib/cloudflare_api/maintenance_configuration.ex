defmodule CloudflareApi.MaintenanceConfiguration do
  @moduledoc ~S"""
  Manage R2 catalog maintenance configuration (`/accounts/:account_id/r2-catalog/:bucket_name/maintenance-configs`).
  """

  def get(client, account_id, bucket_name) do
    request(client, :get, base(account_id, bucket_name))
  end

  def update(client, account_id, bucket_name, params) when is_map(params) do
    request(client, :post, base(account_id, bucket_name), params)
  end

  defp base(account_id, bucket_name),
    do: "/accounts/#{account_id}/r2-catalog/#{bucket_name}/maintenance-configs"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
      end

    handle_response(result)
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
