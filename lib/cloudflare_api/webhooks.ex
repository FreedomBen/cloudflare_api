defmodule CloudflareApi.Webhooks do
  @moduledoc ~S"""
  Manage Realtime Kit webhooks (`/accounts/:account_id/realtime/kit/:app_id/webhooks`).
  """

  @doc ~S"""
  List all webhooks for an app (`GET /accounts/:account_id/realtime/kit/:app_id/webhooks`).
  """
  def list(client, account_id, app_id) do
    c(client)
    |> Tesla.get(base_path(account_id, app_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a webhook (`POST /accounts/:account_id/realtime/kit/:app_id/webhooks`).
  """
  def create(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a webhook (`GET /accounts/:account_id/realtime/kit/:app_id/webhooks/:webhook_id`).
  """
  def get(client, account_id, app_id, webhook_id) do
    c(client)
    |> Tesla.get(webhook_path(account_id, app_id, webhook_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch a webhook (`PATCH /accounts/:account_id/realtime/kit/:app_id/webhooks/:webhook_id`).
  """
  def patch(client, account_id, app_id, webhook_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(webhook_path(account_id, app_id, webhook_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace a webhook (`PUT /accounts/:account_id/realtime/kit/:app_id/webhooks/:webhook_id`).
  """
  def replace(client, account_id, app_id, webhook_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(webhook_path(account_id, app_id, webhook_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a webhook (`DELETE /accounts/:account_id/realtime/kit/:app_id/webhooks/:webhook_id`).
  """
  def delete(client, account_id, app_id, webhook_id) do
    c(client)
    |> Tesla.delete(webhook_path(account_id, app_id, webhook_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id, app_id),
    do: "/accounts/#{account_id}/realtime/kit/#{app_id}/webhooks"

  defp webhook_path(account_id, app_id, webhook_id),
    do: base_path(account_id, app_id) <> "/#{webhook_id}"

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
