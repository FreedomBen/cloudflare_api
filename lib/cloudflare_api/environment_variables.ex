defmodule CloudflareApi.EnvironmentVariables do
  @moduledoc ~S"""
  Manage build trigger environment variables
  (`/accounts/:account_id/builds/triggers/:trigger_uuid/environment_variables`).
  """

  def list(client, account_id, trigger_uuid, opts \\ []) do
    request(client, :get, base(account_id, trigger_uuid) <> query(opts))
  end

  def upsert(client, account_id, trigger_uuid, params) when is_map(params) do
    request(client, :patch, base(account_id, trigger_uuid), params)
  end

  def delete(client, account_id, trigger_uuid, key) do
    request(client, :delete, base(account_id, trigger_uuid) <> "/#{key}", %{})
  end

  defp base(account_id, trigger_uuid) do
    "/accounts/#{account_id}/builds/triggers/#{trigger_uuid}/environment_variables"
  end

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
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
