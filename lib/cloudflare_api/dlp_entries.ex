defmodule CloudflareApi.DlpEntries do
  @moduledoc ~S"""
  Manage DLP entries via `/accounts/:account_id/dlp/entries`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List entries (`GET /accounts/:account_id/dlp/entries`).
  """
  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  @doc ~S"""
  Create a custom entry (`POST /accounts/:account_id/dlp/entries`).
  """
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Fetch a DLP entry (`GET /accounts/:account_id/dlp/entries/:entry_id`).
  """
  def get(client, account_id, entry_id) do
    request(client, :get, entry_path(account_id, entry_id))
  end

  @doc ~S"""
  Update an entry (`PUT /accounts/:account_id/dlp/entries/:entry_id`).
  """
  def update(client, account_id, entry_id, params) when is_map(params) do
    request(client, :put, entry_path(account_id, entry_id), params)
  end

  @doc ~S"""
  Update a custom entry (`PUT /accounts/:account_id/dlp/entries/custom/:entry_id`).
  """
  def update_custom_entry(client, account_id, entry_id, params) when is_map(params) do
    request(client, :put, base_path(account_id) <> "/custom/#{entry_id}", params)
  end

  @doc ~S"""
  Update a predefined entry (`PUT /accounts/:account_id/dlp/entries/predefined/:entry_id`).
  """
  def update_predefined_entry(client, account_id, entry_id, params) when is_map(params) do
    request(client, :put, base_path(account_id) <> "/predefined/#{entry_id}", params)
  end

  @doc ~S"""
  Delete an entry (`DELETE /accounts/:account_id/dlp/entries/:entry_id`).
  """
  def delete(client, account_id, entry_id) do
    request(client, :delete, entry_path(account_id, entry_id), %{})
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/dlp/entries"
  defp entry_path(account_id, entry_id), do: base_path(account_id) <> "/#{entry_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
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
