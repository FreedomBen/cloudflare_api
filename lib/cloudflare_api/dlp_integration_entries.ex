defmodule CloudflareApi.DlpIntegrationEntries do
  @moduledoc ~S"""
  Manage integration entries under `/accounts/:account_id/dlp/entries/integration`.
  """

  @doc ~S"""
  Create an integration entry (`POST /accounts/:account_id/dlp/entries/integration`).
  """
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Update an integration entry (`PUT /accounts/:account_id/dlp/entries/integration/:entry_id`).
  """
  def update(client, account_id, entry_id, params) when is_map(params) do
    request(client, :put, entry_path(account_id, entry_id), params)
  end

  @doc ~S"""
  Delete an integration entry (`DELETE /accounts/:account_id/dlp/entries/integration/:entry_id`).
  """
  def delete(client, account_id, entry_id) do
    request(client, :delete, entry_path(account_id, entry_id), %{})
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/dlp/entries/integration"
  defp entry_path(account_id, entry_id), do: base_path(account_id) <> "/#{entry_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
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
