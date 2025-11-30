defmodule CloudflareApi.Dataset do
  @moduledoc ~S"""
  Manage Cloudforce One datasets under
  `/accounts/:account_id/cloudforce-one/events/dataset`.
  """

  use CloudflareApi.Typespecs

  def list(client, account_id) do
    request(client, :get, base(account_id))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/create", params)
  end

  def get(client, account_id, dataset_id) do
    request(client, :get, dataset_path(account_id, dataset_id))
  end

  def update(client, account_id, dataset_id, params) when is_map(params) do
    request(client, :patch, dataset_path(account_id, dataset_id), params)
  end

  def update_alt(client, account_id, dataset_id, params) when is_map(params) do
    request(client, :post, dataset_path(account_id, dataset_id), params)
  end

  @doc ~S"""
  Populate dataset lookup tables from existing Events data
  (`POST /accounts/:account_id/cloudforce-one/events/datasets/populate`).
  """
  def populate(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "s/populate", params)
  end

  def delete(client, account_id, dataset_id) do
    request(client, :delete, dataset_path(account_id, dataset_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/cloudforce-one/events/dataset"
  defp dataset_path(account_id, dataset_id), do: base(account_id) <> "/#{dataset_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
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
