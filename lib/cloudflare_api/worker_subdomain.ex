defmodule CloudflareApi.WorkerSubdomain do
  @moduledoc ~S"""
  Account-level Worker subdomain helpers under `/accounts/:account_id/workers/subdomain`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the Workers subdomain for an account (`GET /accounts/:account_id/workers/subdomain`).
  """
  def get(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create or update a subdomain (`PUT /accounts/:account_id/workers/subdomain`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete the Workers subdomain (`DELETE /accounts/:account_id/workers/subdomain`).
  """
  def delete(client, account_id) do
    c(client)
    |> Tesla.delete(base_path(account_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/workers/subdomain"

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
