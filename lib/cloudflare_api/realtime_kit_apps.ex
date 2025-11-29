defmodule CloudflareApi.RealtimeKitApps do
  @moduledoc ~S"""
  Manage Realtime Kit apps.
  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/realtime/kit/apps")
    |> handle_response()
  end

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/accounts/#{account_id}/realtime/kit/apps", params)
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
