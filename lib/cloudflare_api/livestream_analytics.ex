defmodule CloudflareApi.LivestreamAnalytics do
  @moduledoc ~S"""
  Retrieve Realtime Kit livestream analytics (daywise and overall aggregates).
  """

  def daywise(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(daywise_path(account_id, app_id) <> query(opts))
    |> handle_response()
  end

  def overall(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(overall_path(account_id, app_id) <> query(opts))
    |> handle_response()
  end

  defp daywise_path(account_id, app_id) do
    "/accounts/#{account_id}/realtime/kit/#{app_id}/analytics/livestreams/daywise"
  end

  defp overall_path(account_id, app_id) do
    "/accounts/#{account_id}/realtime/kit/#{app_id}/analytics/livestreams/overall"
  end

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
