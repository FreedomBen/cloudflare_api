defmodule CloudflareApi.NotificationWebhooks do
  @moduledoc ~S"""
  Manage webhook destinations for Cloudflare alerting
  (`/accounts/:account_id/alerting/v3/destinations/webhooks`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List webhook destinations (`GET /accounts/:account_id/alerting/v3/destinations/webhooks`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a webhook (`POST /accounts/:account_id/alerting/v3/destinations/webhooks`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a webhook (`GET /accounts/:account_id/alerting/v3/destinations/webhooks/:webhook_id`).
  """
  def get(client, account_id, webhook_id) do
    c(client)
    |> Tesla.get(webhook_path(account_id, webhook_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a webhook (`PUT /accounts/:account_id/alerting/v3/destinations/webhooks/:webhook_id`).
  """
  def update(client, account_id, webhook_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(webhook_path(account_id, webhook_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a webhook (`DELETE /accounts/:account_id/alerting/v3/destinations/webhooks/:webhook_id`).
  """
  def delete(client, account_id, webhook_id) do
    c(client)
    |> Tesla.delete(webhook_path(account_id, webhook_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/alerting/v3/destinations/webhooks"

  defp webhook_path(account_id, webhook_id), do: base_path(account_id) <> "/#{webhook_id}"

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
