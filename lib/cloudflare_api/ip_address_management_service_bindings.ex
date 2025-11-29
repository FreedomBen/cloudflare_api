defmodule CloudflareApi.IpAddressManagementServiceBindings do
  @moduledoc ~S"""
  Service binding helpers for IP Address Management prefixes.
  """

  def list(client, account_id, prefix_id) do
    request(client, :get, bindings_path(account_id, prefix_id))
  end

  def get(client, account_id, prefix_id, binding_id) do
    request(client, :get, binding_path(account_id, prefix_id, binding_id))
  end

  def create(client, account_id, prefix_id, params) when is_map(params) do
    request(client, :post, bindings_path(account_id, prefix_id), params)
  end

  def delete(client, account_id, prefix_id, binding_id) do
    request(client, :delete, binding_path(account_id, prefix_id, binding_id), %{})
  end

  def list_services(client, account_id) do
    request(client, :get, "/accounts/#{account_id}/addressing/services")
  end

  defp bindings_path(account_id, prefix_id),
    do: "/accounts/#{account_id}/addressing/prefixes/#{prefix_id}/bindings"

  defp binding_path(account_id, prefix_id, binding_id),
    do: bindings_path(account_id, prefix_id) <> "/#{binding_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)
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
