defmodule CloudflareApi.ZeroTrustSeats do
  @moduledoc ~S"""
  Manage Zero Trust Access seats (`PATCH /accounts/:account_id/access/seats`).
  """

  @doc """
  Update user seats (`PATCH /accounts/:account_id/access/seats`).
  """
  def update(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(base_path(account_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/seats"

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
