defmodule CloudflareApi.RequestForInformation do
  @moduledoc ~S"""
  Cloudforce One Request for Information (RFI) helpers under
  `/accounts/:account_id/cloudforce-one/requests`.
  """

  def list(client, account_id, params \\ %{}) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id) <> "/new", params)
  end

  def constants(client, account_id) do
    request(client, :get, base_path(account_id) <> "/constants")
  end

  def quota(client, account_id) do
    request(client, :get, base_path(account_id) <> "/quota")
  end

  def types(client, account_id) do
    request(client, :get, base_path(account_id) <> "/types")
  end

  def get(client, account_id, request_id) do
    request(client, :get, request_path(account_id, request_id))
  end

  def update(client, account_id, request_id, params) when is_map(params) do
    request(client, :put, request_path(account_id, request_id), params)
  end

  def delete(client, account_id, request_id) do
    request(client, :delete, request_path(account_id, request_id))
  end

  def list_assets(client, account_id, request_id, params \\ %{}) when is_map(params) do
    request(client, :post, request_path(account_id, request_id) <> "/asset", params)
  end

  def create_asset(client, account_id, request_id, params) when is_map(params) do
    request(client, :post, request_path(account_id, request_id) <> "/asset/new", params)
  end

  def get_asset(client, account_id, request_id, asset_id) do
    request(client, :get, asset_path(account_id, request_id, asset_id))
  end

  def update_asset(client, account_id, request_id, asset_id, params) when is_map(params) do
    request(client, :put, asset_path(account_id, request_id, asset_id), params)
  end

  def delete_asset(client, account_id, request_id, asset_id) do
    request(client, :delete, asset_path(account_id, request_id, asset_id))
  end

  def list_messages(client, account_id, request_id, params \\ %{}) when is_map(params) do
    request(client, :post, request_path(account_id, request_id) <> "/message", params)
  end

  def create_message(client, account_id, request_id, params) when is_map(params) do
    request(client, :post, request_path(account_id, request_id) <> "/message/new", params)
  end

  def get_message(client, account_id, request_id, message_id) do
    request(client, :get, message_path(account_id, request_id, message_id))
  end

  def update_message(client, account_id, request_id, message_id, params) when is_map(params) do
    request(client, :put, message_path(account_id, request_id, message_id), params)
  end

  def delete_message(client, account_id, request_id, message_id) do
    request(client, :delete, message_path(account_id, request_id, message_id))
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/cloudforce-one/requests"
  defp request_path(account_id, request_id), do: base_path(account_id) <> "/#{encode(request_id)}"

  defp asset_path(account_id, request_id, asset_id) do
    request_path(account_id, request_id) <> "/asset/#{encode(asset_id)}"
  end

  defp message_path(account_id, request_id, message_id) do
    request_path(account_id, request_id) <> "/message/#{encode(message_id)}"
  end

  defp request(client_or_fun, method, url, body \\ nil) do
    client = c(client_or_fun)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, nil} -> Tesla.delete(client, url, body: %{})
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
      end

    handle_response(result)
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
