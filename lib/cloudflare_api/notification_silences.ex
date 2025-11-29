defmodule CloudflareApi.NotificationSilences do
  @moduledoc ~S"""
  Manage alert silences (`/accounts/:account_id/alerting/v3/silences`).
  """

  @doc ~S"""
  List configured silences via `GET /accounts/:account_id/alerting/v3/silences`.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a silence (`POST /accounts/:account_id/alerting/v3/silences`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update an existing silence definition in bulk.

  Wraps `PUT /accounts/:account_id/alerting/v3/silences`, where the body
  contains the silence definition to update.
  """
  def update(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a specific silence (`GET /accounts/:account_id/alerting/v3/silences/:silence_id`).
  """
  def get(client, account_id, silence_id) do
    c(client)
    |> Tesla.get(silence_path(account_id, silence_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a silence (`DELETE /accounts/:account_id/alerting/v3/silences/:silence_id`).
  """
  def delete(client, account_id, silence_id) do
    c(client)
    |> Tesla.delete(silence_path(account_id, silence_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/alerting/v3/silences"

  defp silence_path(account_id, silence_id), do: base_path(account_id) <> "/#{silence_id}"

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts),
    do: base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
