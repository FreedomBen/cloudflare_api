defmodule CloudflareApi.MagicSiteNetflowConfig do
  @moduledoc ~S"""
  Manage Magic Site NetFlow configuration (`/accounts/:account_id/magic/sites/:site_id/netflow_config`).
  """

  def get(client, account_id, site_id) do
    request(client, :get, base(account_id, site_id))
  end

  def create(client, account_id, site_id, params) when is_map(params) do
    request(client, :post, base(account_id, site_id), params)
  end

  def update(client, account_id, site_id, params) when is_map(params) do
    request(client, :put, base(account_id, site_id), params)
  end

  def patch(client, account_id, site_id, params) when is_map(params) do
    request(client, :patch, base(account_id, site_id), params)
  end

  def delete(client, account_id, site_id) do
    request(client, :delete, base(account_id, site_id), %{})
  end

  defp base(account_id, site_id),
    do: "/accounts/#{account_id}/magic/sites/#{site_id}/netflow_config"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
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
