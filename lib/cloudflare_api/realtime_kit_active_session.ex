defmodule CloudflareApi.RealtimeKitActiveSession do
  @moduledoc ~S"""
  Manage active sessions in Realtime Kit meetings.
  """

  def get(client, account_id, app_id, meeting_id) do
    get_request(client, base_path(account_id, app_id, meeting_id))
  end

  def kick(client, account_id, app_id, meeting_id, params) when is_map(params) do
    post_request(client, action_path(account_id, app_id, meeting_id, "kick"), params)
  end

  def kick_all(client, account_id, app_id, meeting_id) do
    post_request(client, action_path(account_id, app_id, meeting_id, "kick-all"), %{})
  end

  def mute(client, account_id, app_id, meeting_id, params) when is_map(params) do
    post_request(client, action_path(account_id, app_id, meeting_id, "mute"), params)
  end

  def mute_all(client, account_id, app_id, meeting_id) do
    post_request(client, action_path(account_id, app_id, meeting_id, "mute-all"), %{})
  end

  def create_poll(client, account_id, app_id, meeting_id, params) when is_map(params) do
    post_request(client, action_path(account_id, app_id, meeting_id, "poll"), params)
  end

  defp base_path(account_id, app_id, meeting_id) do
    "/accounts/#{account_id}/realtime/kit/#{app_id}/meetings/#{meeting_id}/active-session"
  end

  defp action_path(account_id, app_id, meeting_id, action) do
    base_path(account_id, app_id, meeting_id) <> "/#{action}"
  end

  defp get_request(client, url) do
    c(client) |> Tesla.get(url) |> handle_response()
  end

  defp post_request(client, url, body) do
    c(client) |> Tesla.post(url, body) |> handle_response()
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
