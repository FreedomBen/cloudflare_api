defmodule CloudflareApi.RealtimeKitAnalytics do
  @moduledoc ~S"""
  Retrieve Realtime Kit analytics (daywise stats).
  """

  def daywise(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(daywise_url(account_id, app_id, opts))
    |> handle_response()
  end

  defp daywise_url(account_id, app_id, []), do: base_path(account_id, app_id)

  defp daywise_url(account_id, app_id, opts) do
    base_path(account_id, app_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, app_id) do
    "/accounts/#{account_id}/realtime/kit/#{app_id}/analytics/daywise"
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
