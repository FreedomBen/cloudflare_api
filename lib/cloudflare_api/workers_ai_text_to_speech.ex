defmodule CloudflareApi.WorkersAiTextToSpeech do
  @moduledoc ~S"""
  Workers AI text-to-speech helpers (Deepgram Aura family + MyShell models).
  """

  @json_models [
    {:run_cf_deepgram_aura_1, "@cf/deepgram/aura-1"},
    {:run_cf_deepgram_aura_2_en, "@cf/deepgram/aura-2-en"},
    {:run_cf_deepgram_aura_2_es, "@cf/deepgram/aura-2-es"},
    {:run_cf_myshell_ai_melotts, "@cf/myshell-ai/melotts"}
  ]

  @websocket_models [
    {:websocket_run_cf_deepgram_aura, "@cf/deepgram/aura"},
    {:websocket_run_cf_deepgram_aura_1, "@cf/deepgram/aura-1"},
    {:websocket_run_cf_deepgram_aura_1_internal, "@cf/deepgram/aura-1-internal"},
    {:websocket_run_cf_deepgram_aura_2, "@cf/deepgram/aura-2"},
    {:websocket_run_cf_deepgram_aura_2_en, "@cf/deepgram/aura-2-en"},
    {:websocket_run_cf_deepgram_aura_2_es, "@cf/deepgram/aura-2-es"}
  ]

  @doc false
  def run_models, do: @json_models

  @doc false
  def websocket_models, do: @websocket_models

  for {fun, model} <- @json_models do
    @doc ~S"""
    Execute the #{model} model (`POST /accounts/:account_id/ai/run/#{model}`).
    """
    def unquote(fun)(client, account_id, body \\ %{}, opts \\ []) do
      post_run(client, account_id, unquote(model), body, opts)
    end
  end

  for {fun, model} <- @websocket_models do
    @doc ~S"""
    Open the websocket endpoint for #{model} (`GET /accounts/:account_id/ai/run/#{model}`).
    """
    def unquote(fun)(client, account_id) do
      c(client)
      |> Tesla.get(run_path(account_id, unquote(model)))
      |> handle_response()
    end
  end

  defp post_run(client, account_id, model, body, opts) do
    c(client)
    |> Tesla.post(with_query(run_path(account_id, model), opts), body)
    |> handle_response()
  end

  defp run_path(account_id, model), do: "/accounts/#{account_id}/ai/run/#{model}"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
