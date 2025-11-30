defmodule CloudflareApi.ZeroTrustRiskScoring do
  @moduledoc ~S"""
  Manage Zero Trust risk scoring behaviors, summaries, and per-user insights.
  """

  use CloudflareApi.Typespecs

  @doc """
  List scoring behaviors (`GET /accounts/:account_id/zt_risk_scoring/behaviors`).
  """
  def list_behaviors(client, account_id) do
    c(client)
    |> Tesla.get(behaviors_path(account_id))
    |> handle_response()
  end

  @doc """
  Update scoring behaviors (`PUT /accounts/:account_id/zt_risk_scoring/behaviors`).
  """
  def update_behaviors(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(behaviors_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Fetch account summary (`GET /accounts/:account_id/zt_risk_scoring/summary`).
  """
  def summary(client, account_id) do
    c(client)
    |> Tesla.get(summary_path(account_id))
    |> handle_response()
  end

  @doc """
  Fetch user summary (`GET /accounts/:account_id/zt_risk_scoring/:user_id`).
  """
  def user_summary(client, account_id, user_id) do
    c(client)
    |> Tesla.get(user_path(account_id, user_id))
    |> handle_response()
  end

  @doc """
  Reset a user's risk score (`POST /accounts/:account_id/zt_risk_scoring/:user_id/reset`).
  """
  def reset_user(client, account_id, user_id, params \\ %{}) do
    c(client)
    |> Tesla.post(reset_path(account_id, user_id), params)
    |> handle_response()
  end

  defp behaviors_path(account_id), do: "/accounts/#{account_id}/zt_risk_scoring/behaviors"
  defp summary_path(account_id), do: "/accounts/#{account_id}/zt_risk_scoring/summary"

  defp user_path(account_id, user_id),
    do: "/accounts/#{account_id}/zt_risk_scoring/#{encode(user_id)}"

  defp reset_path(account_id, user_id),
    do: user_path(account_id, user_id) <> "/reset"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
