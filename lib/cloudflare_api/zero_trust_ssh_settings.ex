defmodule CloudflareApi.ZeroTrustSshSettings do
  @moduledoc ~S"""
  Manage Zero Trust SSH audit settings (`/accounts/:account_id/gateway/audit_ssh_settings`).
  """

  @doc """
  Fetch SSH settings (`GET /accounts/:account_id/gateway/audit_ssh_settings`).
  """
  def get(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc """
  Update SSH settings (`PUT /accounts/:account_id/gateway/audit_ssh_settings`).
  """
  def update(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Rotate the SSH account seed (`POST /accounts/:account_id/gateway/audit_ssh_settings/rotate_seed`).
  """
  def rotate_seed(client, account_id) do
    c(client)
    |> Tesla.post(rotate_path(account_id), %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/audit_ssh_settings"

  defp rotate_path(account_id), do: base_path(account_id) <> "/rotate_seed"

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
