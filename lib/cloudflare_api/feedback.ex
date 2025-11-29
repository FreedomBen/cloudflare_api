defmodule CloudflareApi.Feedback do
  @moduledoc ~S"""
  Bot Management feedback helpers (`/zones/:zone_id/bot_management/feedback`).
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get("/zones/#{zone_id}/bot_management/feedback" <> query(opts))
    |> handle()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/zones/#{zone_id}/bot_management/feedback", params)
    |> handle()
  end

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
