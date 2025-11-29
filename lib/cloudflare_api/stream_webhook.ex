defmodule CloudflareApi.StreamWebhook do
  @moduledoc ~S"""
  Manage Stream webhooks under `/accounts/:account_id/stream/webhook`.
  """

  @doc ~S"""
  Retrieve webhook configuration (`GET /stream/webhook`).
  """
  def get(client, account_id) do
    c(client)
    |> Tesla.get(path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create/update webhook configuration (`PUT /stream/webhook`).
  """
  def upsert(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete the webhook configuration (`DELETE /stream/webhook`).
  """
  def delete(client, account_id) do
    c(client)
    |> Tesla.delete(path(account_id), body: %{})
    |> handle_response()
  end

  defp path(account_id), do: "/accounts/#{account_id}/stream/webhook"

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
