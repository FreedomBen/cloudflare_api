defmodule CloudflareApi.DlpPredefinedEntries do
  @moduledoc ~S"""
  Manage predefined entries via `/accounts/:account_id/dlp/entries/predefined`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Create a predefined entry (`POST /accounts/:account_id/dlp/entries/predefined`).
  """
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Delete a predefined entry (`DELETE /accounts/:account_id/dlp/entries/predefined/:entry_id`).
  """
  def delete(client, account_id, entry_id) do
    request(client, :delete, entry_path(account_id, entry_id), %{})
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/dlp/entries/predefined"
  defp entry_path(account_id, entry_id), do: base_path(account_id) <> "/#{entry_id}"

  defp request(client, method, url, body) do
    client = c(client)

    result =
      case {method, body} do
        {:post, %{} = params} -> Tesla.post(client, url, params)
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
