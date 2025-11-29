defmodule CloudflareApi.AccountRequestTracer do
  @moduledoc ~S"""
  Trigger the account request tracer.
  """

  @doc ~S"""
  Trace account request tracer.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRequestTracer.trace(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def trace(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/request-tracer/trace", params)
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
