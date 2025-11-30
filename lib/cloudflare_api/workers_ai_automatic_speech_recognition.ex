defmodule CloudflareApi.WorkersAiAutomaticSpeechRecognition do
  @moduledoc ~S"""
  Wraps the Workers AI Automatic Speech Recognition models under
  `/accounts/:account_id/ai/run`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Open the websocket endpoint for Deepgram Flux
  (`GET /accounts/:account_id/ai/run/@cf/deepgram/flux`).
  """
  def websocket_run_cf_deepgram_flux(client, account_id) do
    websocket_run(client, account_id, "@cf/deepgram/flux")
  end

  @doc ~S"""
  Execute Deepgram Flux (`POST .../@cf/deepgram/flux`).
  """
  def run_cf_deepgram_flux(client, account_id, body \\ %{}, opts \\ []) do
    post_run(client, account_id, "@cf/deepgram/flux", body, opts)
  end

  @doc ~S"""
  Open the websocket endpoint for Deepgram Nova 3
  (`GET .../@cf/deepgram/nova-3`).
  """
  def websocket_run_cf_deepgram_nova3(client, account_id) do
    websocket_run(client, account_id, "@cf/deepgram/nova-3")
  end

  @doc ~S"""
  Execute Deepgram Nova 3 (`POST .../@cf/deepgram/nova-3`).
  """
  def run_cf_deepgram_nova3(client, account_id, body \\ %{}, opts \\ []) do
    post_run(client, account_id, "@cf/deepgram/nova-3", body, opts)
  end

  @doc ~S"""
  Open the websocket endpoint for Deepgram Nova 3 Internal
  (`GET .../@cf/deepgram/nova-3-internal`).
  """
  def websocket_run_cf_deepgram_nova3_internal(client, account_id) do
    websocket_run(client, account_id, "@cf/deepgram/nova-3-internal")
  end

  @doc ~S"""
  Execute OpenAI Whisper (`POST .../@cf/openai/whisper`).

  Accepts binary audio payloads.
  """
  @spec run_cf_openai_whisper(
          CloudflareApi.client(),
          String.t(),
          iodata(),
          CloudflareApi.options()
        ) :: CloudflareApi.result(term())
  def run_cf_openai_whisper(client, account_id, body \\ <<>>, opts \\ []) do
    post_run(client, account_id, "@cf/openai/whisper", body, opts)
  end

  @doc ~S"""
  Execute OpenAI Whisper Large V3 Turbo (`POST .../@cf/openai/whisper-large-v3-turbo`).
  """
  def run_cf_openai_whisper_large_v3_turbo(client, account_id, body \\ %{}, opts \\ []) do
    post_run(client, account_id, "@cf/openai/whisper-large-v3-turbo", body, opts)
  end

  @doc ~S"""
  Execute OpenAI Whisper Tiny EN (`POST .../@cf/openai/whisper-tiny-en`).

  Accepts binary audio payloads.
  """
  @spec run_cf_openai_whisper_tiny_en(
          CloudflareApi.client(),
          String.t(),
          iodata(),
          CloudflareApi.options()
        ) :: CloudflareApi.result(term())
  def run_cf_openai_whisper_tiny_en(client, account_id, body \\ <<>>, opts \\ []) do
    post_run(client, account_id, "@cf/openai/whisper-tiny-en", body, opts)
  end

  defp websocket_run(client, account_id, model) do
    c(client)
    |> Tesla.get(run_path(account_id, model))
    |> handle_response()
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
