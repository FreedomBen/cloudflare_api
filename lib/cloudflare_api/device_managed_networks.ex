defmodule CloudflareApi.DeviceManagedNetworks do
  @moduledoc ~S"""
  Manage device managed networks via `/accounts/:account_id/devices/networks`.
  """

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  def get(client, account_id, network_id) do
    request(client, :get, network_path(account_id, network_id))
  end

  def update(client, account_id, network_id, params) when is_map(params) do
    request(client, :put, network_path(account_id, network_id), params)
  end

  def delete(client, account_id, network_id) do
    request(client, :delete, network_path(account_id, network_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/devices/networks"
  defp network_path(account_id, network_id), do: base(account_id) <> "/#{network_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
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
