defmodule CloudflareApi.NotificationDestinationsPagerduty do
  @moduledoc ~S"""
  Manage PagerDuty destinations for Cloudflare alerting
  (`/accounts/:account_id/alerting/v3/destinations/pagerduty`).
  """

  @doc ~S"""
  List connected PagerDuty services (`GET /accounts/:account_id/alerting/v3/destinations/pagerduty`).
  """
  def list_services(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Remove PagerDuty services (`DELETE /accounts/:account_id/alerting/v3/destinations/pagerduty`).
  Pass the request body as `params` (for example `%{"service_ids" => ["svc"]}`).
  """
  def delete_services(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.delete(base_path(account_id), body: params)
    |> handle_response()
  end

  @doc ~S"""
  Create a PagerDuty integration token
  (`POST /accounts/:account_id/alerting/v3/destinations/pagerduty/connect`).
  """
  def create_connect_token(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(connect_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve the status of a connect token (`GET /accounts/:account_id/alerting/v3/destinations/pagerduty/connect/:token_id`).
  """
  def get_connect_token(client, account_id, token_id) do
    c(client)
    |> Tesla.get(connect_token_path(account_id, token_id))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/alerting/v3/destinations/pagerduty"
  defp connect_path(account_id), do: base_path(account_id) <> "/connect"
  defp connect_token_path(account_id, token_id), do: connect_path(account_id) <> "/#{token_id}"

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
