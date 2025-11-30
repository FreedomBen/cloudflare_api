defmodule CloudflareApi.NotificationAlertTypes do
  @moduledoc ~S"""
  Fetch available alert types for account-level alerting
  (`/accounts/:account_id/alerting/v3/available_alerts`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List alert types available to the account via
  `GET /accounts/:account_id/alerting/v3/available_alerts`.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/alerting/v3/available_alerts"

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
