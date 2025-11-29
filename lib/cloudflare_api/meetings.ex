defmodule CloudflareApi.Meetings do
  @moduledoc ~S"""
  Manage Realtime Kit meetings and participants (`/accounts/:account_id/realtime/kit/:app_id/meetings`).
  """

  def list(client, account_id, app_id, opts \\ []) do
    request(client, :get, meetings_path(account_id, app_id) <> query(opts))
  end

  def create(client, account_id, app_id, params) when is_map(params) do
    request(client, :post, meetings_path(account_id, app_id), params)
  end

  def get(client, account_id, app_id, meeting_id) do
    request(client, :get, meeting_path(account_id, app_id, meeting_id))
  end

  def update(client, account_id, app_id, meeting_id, params) when is_map(params) do
    request(client, :patch, meeting_path(account_id, app_id, meeting_id), params)
  end

  def replace(client, account_id, app_id, meeting_id, params) when is_map(params) do
    request(client, :put, meeting_path(account_id, app_id, meeting_id), params)
  end

  def list_participants(client, account_id, app_id, meeting_id, opts \\ []) do
    request(
      client,
      :get,
      participants_path(account_id, app_id, meeting_id) <> query(opts)
    )
  end

  def add_participant(client, account_id, app_id, meeting_id, params) when is_map(params) do
    request(client, :post, participants_path(account_id, app_id, meeting_id), params)
  end

  def get_participant(client, account_id, app_id, meeting_id, participant_id) do
    request(
      client,
      :get,
      participant_path(account_id, app_id, meeting_id, participant_id)
    )
  end

  def update_participant(client, account_id, app_id, meeting_id, participant_id, params)
      when is_map(params) do
    request(
      client,
      :patch,
      participant_path(account_id, app_id, meeting_id, participant_id),
      params
    )
  end

  def delete_participant(client, account_id, app_id, meeting_id, participant_id) do
    request(
      client,
      :delete,
      participant_path(account_id, app_id, meeting_id, participant_id)
    )
  end

  def regenerate_participant_token(client, account_id, app_id, meeting_id, participant_id) do
    request(
      client,
      :post,
      participant_path(account_id, app_id, meeting_id, participant_id) <> "/token",
      %{}
    )
  end

  defp meetings_path(account_id, app_id),
    do: "/accounts/#{account_id}/realtime/kit/#{app_id}/meetings"

  defp meeting_path(account_id, app_id, meeting_id),
    do: meetings_path(account_id, app_id) <> "/#{meeting_id}"

  defp participants_path(account_id, app_id, meeting_id),
    do: meeting_path(account_id, app_id, meeting_id) <> "/participants"

  defp participant_path(account_id, app_id, meeting_id, participant_id),
    do: participants_path(account_id, app_id, meeting_id) <> "/#{participant_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: 204}}), do: {:ok, :no_content}

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
