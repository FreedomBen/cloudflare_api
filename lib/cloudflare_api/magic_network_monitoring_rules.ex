defmodule CloudflareApi.MagicNetworkMonitoringRules do
  @moduledoc ~S"""
  Manage Magic Network Monitoring rules (`/accounts/:account_id/mnm/rules`).
  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  def replace(client, account_id, params) when is_map(params) do
    request(client, :put, base(account_id), params)
  end

  def get(client, account_id, rule_id) do
    request(client, :get, rule_path(account_id, rule_id))
  end

  def update(client, account_id, rule_id, params) when is_map(params) do
    request(client, :patch, rule_path(account_id, rule_id), params)
  end

  def update_advertisement(client, account_id, rule_id, params) when is_map(params) do
    request(client, :patch, rule_path(account_id, rule_id) <> "/advertisement", params)
  end

  def delete(client, account_id, rule_id) do
    request(client, :delete, rule_path(account_id, rule_id))
  end

  defp base(account_id), do: "/accounts/#{account_id}/mnm/rules"
  defp rule_path(account_id, rule_id), do: base(account_id) <> "/#{rule_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
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
