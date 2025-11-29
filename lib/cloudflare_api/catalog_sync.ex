defmodule CloudflareApi.CatalogSync do
  @moduledoc ~S"""
  Manage Catalog Syncs for Magic Cloud.
  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  def create(client, account_id, params, headers \\ []) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params, headers: headers)
    |> handle_response()
  end

  def prebuilt_policies(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(account_id) <> "/prebuilt-policies" <> query_suffix(opts))
    |> handle_response()
  end

  def get(client, account_id, sync_id) do
    c(client)
    |> Tesla.get(sync_path(account_id, sync_id))
    |> handle_response()
  end

  def update(client, account_id, sync_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(sync_path(account_id, sync_id), params)
    |> handle_response()
  end

  def patch(client, account_id, sync_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(sync_path(account_id, sync_id), params)
    |> handle_response()
  end

  def delete(client, account_id, sync_id, opts \\ []) do
    c(client)
    |> Tesla.delete(sync_path(account_id, sync_id) <> query_suffix(opts))
    |> handle_response()
  end

  def refresh(client, account_id, sync_id) do
    c(client)
    |> Tesla.post(sync_path(account_id, sync_id) <> "/refresh", %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/magic/cloud/catalog-syncs"
  defp sync_path(account_id, sync_id), do: base_path(account_id) <> "/#{sync_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
