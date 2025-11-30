defmodule CloudflareApi.ZeroTrustApplicationsReviewStatus do
  @moduledoc ~S"""
  Manage Zero Trust application review status
  (`/accounts/:account_id/gateway/apps/review_status`).
  """

  use CloudflareApi.Typespecs

  @doc """
  Fetch review status (`GET /accounts/:account_id/gateway/apps/review_status`).
  """
  def get(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc """
  Update review status (`PUT /accounts/:account_id/gateway/apps/review_status`).
  """
  def update(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/apps/review_status"

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
