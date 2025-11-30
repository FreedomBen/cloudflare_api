defmodule CloudflareApi.WorkerTailLogs do
  @moduledoc ~S"""
  Manage Workers tail sessions under
  `/accounts/:account_id/workers/scripts/:script_name/tails`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List tail sessions (`GET .../tails`).
  """
  def list(client, account_id, script_name) do
    c(client)
    |> Tesla.get(tails_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Start a tail session (`POST .../tails`).
  """
  def start(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(tails_path(account_id, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a tail session (`DELETE .../tails/:id`).
  """
  def delete(client, account_id, script_name, tail_id) do
    c(client)
    |> Tesla.delete(tail_path(account_id, script_name, tail_id), body: %{})
    |> handle_response()
  end

  defp tails_path(account_id, script_name),
    do: "/accounts/#{account_id}/workers/scripts/#{encode(script_name)}/tails"

  defp tail_path(account_id, script_name, tail_id),
    do: tails_path(account_id, script_name) <> "/#{encode(tail_id)}"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
