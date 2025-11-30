defmodule CloudflareApi.WorkerAccountSettings do
  @moduledoc ~S"""
  Manage Workers account settings (`/accounts/:account_id/workers/account-settings`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch Worker account settings (`GET /accounts/:account_id/workers/account-settings`).
  """
  def get_settings(client, account_id) do
    c(client)
    |> Tesla.get(account_settings_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create or update Worker account settings (`PUT /accounts/:account_id/workers/account-settings`).
  """
  def update_settings(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(account_settings_path(account_id), params)
    |> handle_response()
  end

  defp account_settings_path(account_id),
    do: "/accounts/#{account_id}/workers/account-settings"

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
