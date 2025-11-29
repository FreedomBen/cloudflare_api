defmodule CloudflareApi.ZeroTrustRiskScoringIntegrations do
  @moduledoc ~S"""
  Manage Zero Trust risk scoring integrations (`/accounts/:account_id/zt_risk_scoring/integrations`).
  """

  @doc """
  List integrations (`GET /accounts/:account_id/zt_risk_scoring/integrations`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc """
  Create an integration (`POST /accounts/:account_id/zt_risk_scoring/integrations`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Fetch by reference ID (`GET .../integrations/reference_id/:reference_id`).
  """
  def get_by_reference_id(client, account_id, reference_id) do
    c(client)
    |> Tesla.get(reference_path(account_id, reference_id))
    |> handle_response()
  end

  @doc """
  Delete an integration (`DELETE .../integrations/:integration_id`).
  """
  def delete(client, account_id, integration_id) do
    c(client)
    |> Tesla.delete(integration_path(account_id, integration_id), body: %{})
    |> handle_response()
  end

  @doc """
  Fetch integration details (`GET .../integrations/:integration_id`).
  """
  def get(client, account_id, integration_id) do
    c(client)
    |> Tesla.get(integration_path(account_id, integration_id))
    |> handle_response()
  end

  @doc """
  Update an integration (`PUT .../integrations/:integration_id`).
  """
  def update(client, account_id, integration_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(integration_path(account_id, integration_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/zt_risk_scoring/integrations"

  defp integration_path(account_id, integration_id),
    do: base_path(account_id) <> "/#{encode(integration_id)}"

  defp reference_path(account_id, reference_id),
    do: base_path(account_id) <> "/reference_id/#{encode(reference_id)}"

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
