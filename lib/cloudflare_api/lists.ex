defmodule CloudflareApi.Lists do
  @moduledoc ~S"""
  Manage Cloudflare Filter Lists for an account (`/accounts/:account_id/rules/lists`).
  """

  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  def get(client, account_id, list_id) do
    request(client, :get, list_path(account_id, list_id))
  end

  def update(client, account_id, list_id, params) when is_map(params) do
    request(client, :put, list_path(account_id, list_id), params)
  end

  def delete(client, account_id, list_id) do
    request(client, :delete, list_path(account_id, list_id), %{})
  end

  def get_items(client, account_id, list_id, opts \\ []) do
    request(client, :get, items_path(account_id, list_id) <> query(opts))
  end

  def create_items(client, account_id, list_id, params) when is_map(params) do
    request(client, :post, items_path(account_id, list_id), params)
  end

  def replace_items(client, account_id, list_id, params) when is_map(params) do
    request(client, :put, items_path(account_id, list_id), params)
  end

  def delete_items(client, account_id, list_id, params) when is_map(params) do
    request(client, :delete, items_path(account_id, list_id), params)
  end

  def get_item(client, account_id, list_id, item_id) do
    request(client, :get, item_path(account_id, list_id, item_id))
  end

  def get_bulk_operation(client, account_id, operation_id) do
    request(client, :get, bulk_path(account_id, operation_id))
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/rules/lists"
  defp list_path(account_id, list_id), do: base_path(account_id) <> "/#{list_id}"
  defp items_path(account_id, list_id), do: list_path(account_id, list_id) <> "/items"

  defp item_path(account_id, list_id, item_id),
    do: items_path(account_id, list_id) <> "/#{item_id}"

  defp bulk_path(account_id, operation_id),
    do: base_path(account_id) <> "/bulk_operations/#{operation_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
