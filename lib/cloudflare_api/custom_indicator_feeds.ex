defmodule CloudflareApi.CustomIndicatorFeeds do
  @moduledoc ~S"""
  Manage Cloudforce One custom indicator feeds.
  """

  alias Tesla.Multipart

  def list(client, account_id) do
    request(:get, base_path(account_id), client)
  end

  def create(client, account_id, params) when is_map(params) do
    request(:post, base_path(account_id), client, params)
  end

  def view_permissions(client, account_id) do
    request(:get, permissions_path(account_id) <> "/view", client)
  end

  def add_permission(client, account_id, params) when is_map(params) do
    request(:put, permissions_path(account_id) <> "/add", client, params)
  end

  def remove_permission(client, account_id, params) when is_map(params) do
    request(:put, permissions_path(account_id) <> "/remove", client, params)
  end

  def get(client, account_id, feed_id) do
    request(:get, feed_path(account_id, feed_id), client)
  end

  def update(client, account_id, feed_id, params) when is_map(params) do
    request(:put, feed_path(account_id, feed_id), client, params)
  end

  def data(client, account_id, feed_id) do
    request(:get, feed_path(account_id, feed_id) <> "/data", client)
  end

  def download(client, account_id, feed_id) do
    request(:get, feed_path(account_id, feed_id) <> "/download", client)
  end

  def update_snapshot(client, account_id, feed_id, %Multipart{} = multipart) do
    c(client)
    |> Tesla.put(feed_path(account_id, feed_id) <> "/snapshot", multipart)
    |> handle_response()
  end

  defp request(method, url, client, body \\ nil) do
    client = c(client)

    case method do
      :get -> Tesla.get(client, url)
      :post -> Tesla.post(client, url, body)
      :put -> Tesla.put(client, url, body)
    end
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/intel/indicator-feeds"
  defp permissions_path(account_id), do: base_path(account_id) <> "/permissions"
  defp feed_path(account_id, feed_id), do: base_path(account_id) <> "/#{feed_id}"

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
