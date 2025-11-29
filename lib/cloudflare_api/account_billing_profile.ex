defmodule CloudflareApi.AccountBillingProfile do
  @moduledoc ~S"""
  Fetch account billing profile information (deprecated API).
  """

  @doc ~S"""
  Get account billing profile.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountBillingProfile.get(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/billing/profile")
    |> handle_response()
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
