defmodule CloudflareApi.Keys do
  @moduledoc ~S"""
  List Workers Observability telemetry keys for an account (`/accounts/:account_id/workers/observability/telemetry/keys`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List telemetry keys (POST /accounts/:account_id/workers/observability/telemetry/keys).

  Accepts an optional filter map that matches the request body described in the
  OpenAPI schema (datasets, filters, time range, etc.).
  """
  def list(client, account_id, params \\ %{}) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  defp base_path(account_id),
    do: "/accounts/#{account_id}/workers/observability/telemetry/keys"

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
