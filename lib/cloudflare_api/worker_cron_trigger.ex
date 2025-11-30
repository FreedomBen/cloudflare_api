defmodule CloudflareApi.WorkerCronTrigger do
  @moduledoc ~S"""
  Manage Worker cron schedules (`/accounts/:account_id/workers/scripts/:script_name/schedules`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List cron triggers for a Worker script (`GET /accounts/:account_id/workers/scripts/:script_name/schedules`).
  """
  def list(client, account_id, script_name) do
    c(client)
    |> Tesla.get(schedules_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Replace cron triggers for a Worker script (`PUT /accounts/:account_id/workers/scripts/:script_name/schedules`).
  """
  def update(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(schedules_path(account_id, script_name), params)
    |> handle_response()
  end

  defp schedules_path(account_id, script_name),
    do: "/accounts/#{account_id}/workers/scripts/#{script_name}/schedules"

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
