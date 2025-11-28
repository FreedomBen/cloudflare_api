defmodule CloudflareApi.AiGatewayEvaluations do
  @moduledoc ~S"""
  Helpers for Cloudflare AI Gateway evaluation endpoints.

  These wrap the `/accounts/:account_id/ai-gateway/gateways/:gateway_id/evaluations`
  paths as well as the account-level evaluation types list.
  """

  @doc ~S"""
  List available evaluation types for an account (`GET /accounts/:account_id/ai-gateway/evaluation-types`).
  """
  def list_types(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/ai-gateway/evaluation-types")
    |> handle_response()
  end

  @doc ~S"""
  List evaluations configured for a gateway. Accepts optional query filters via `opts`.
  """
  def list(client, account_id, gateway_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, gateway_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new evaluation for the gateway (`POST /evaluations`).
  """
  def create(client, account_id, gateway_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, gateway_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch an evaluation by ID.
  """
  def get(client, account_id, gateway_id, evaluation_id) do
    c(client)
    |> Tesla.get(evaluation_path(account_id, gateway_id, evaluation_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete an evaluation (`DELETE /evaluations/:id`).
  """
  def delete(client, account_id, gateway_id, evaluation_id) do
    c(client)
    |> Tesla.delete(evaluation_path(account_id, gateway_id, evaluation_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, gateway_id, []), do: base_path(account_id, gateway_id)

  defp list_url(account_id, gateway_id, opts) do
    base_path(account_id, gateway_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, gateway_id) do
    "/accounts/#{account_id}/ai-gateway/gateways/#{gateway_id}/evaluations"
  end

  defp evaluation_path(account_id, gateway_id, evaluation_id) do
    base_path(account_id, gateway_id) <> "/#{evaluation_id}"
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
