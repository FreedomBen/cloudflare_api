defmodule CloudflareApi.ZeroTrustGatewayCategories do
  @moduledoc ~S"""
  List Zero Trust Gateway categories (`/accounts/:account_id/gateway/categories`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List categories (`GET /accounts/:account_id/gateway/categories`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/categories"

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
