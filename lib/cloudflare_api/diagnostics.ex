defmodule CloudflareApi.Diagnostics do
  @moduledoc ~S"""
  Diagnostics helpers for `/accounts/:account_id/diagnostics/traceroute`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Trigger a traceroute diagnostic (`POST /accounts/:account_id/diagnostics/traceroute`).
  """
  def traceroute(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/diagnostics/traceroute", params)
    |> handle()
  end

  defp handle({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
