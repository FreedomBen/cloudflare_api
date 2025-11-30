defmodule CloudflareApi.WorkersAiDumbPipe do
  @moduledoc ~S"""
  Websocket endpoints for Workers AI Dumb Pipe models.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Open the websocket endpoint for Pipecat Smart Turn V2
  (`GET /accounts/:account_id/ai/run/@cf/pipecat-ai/smart-turn-v2`).
  """
  def websocket_run_cf_pipecat_ai_smart_turn_v2(client, account_id) do
    websocket_run(client, account_id, "@cf/pipecat-ai/smart-turn-v2")
  end

  @doc ~S"""
  Open the websocket endpoint for Pipecat Smart Turn V3
  (`GET /accounts/:account_id/ai/run/@cf/pipecat-ai/smart-turn-v3`).
  """
  def websocket_run_cf_pipecat_ai_smart_turn_v3(client, account_id) do
    websocket_run(client, account_id, "@cf/pipecat-ai/smart-turn-v3")
  end

  defp websocket_run(client, account_id, model) do
    c(client)
    |> Tesla.get(run_path(account_id, model))
    |> handle_response()
  end

  defp run_path(account_id, model), do: "/accounts/#{account_id}/ai/run/#{model}"

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
