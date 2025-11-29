defmodule CloudflareApi.WorkersAiAutomaticSpeechRecognitionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiAutomaticSpeechRecognition, as: ASR

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "run_cf_deepgram_flux/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/run/@cf/deepgram/flux?queueRequest=true&tags=model"

      assert Jason.decode!(body) == %{"audio" => "b64"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "job"}}}}
    end)

    assert {:ok, %{"id" => "job"}} =
             ASR.run_cf_deepgram_flux(client, "acc", %{"audio" => "b64"},
               queueRequest: true,
               tags: "model"
             )
  end

  test "run_cf_openai_whisper/4 sends binary payload", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/ai/run/@cf/openai/whisper"
      assert body == <<0, 1, 2>>
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"text" => "hi"}}}}
    end)

    assert {:ok, %{"text" => "hi"}} =
             ASR.run_cf_openai_whisper(client, "acc", <<0, 1, 2>>)
  end

  test "websocket_run_cf_deepgram_nova3/2 calls GET endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/ai/run/@cf/deepgram/nova-3"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             ASR.websocket_run_cf_deepgram_nova3(client, "acc")
  end

  test "websocket_run_cf_deepgram_nova3_internal/2 hits correct path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/run/@cf/deepgram/nova-3-internal"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ASR.websocket_run_cf_deepgram_nova3_internal(client, "acc")
  end

  test "run_cf_openai_whisper_tiny_en propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} =
             ASR.run_cf_openai_whisper_tiny_en(client, "acc", <<1, 2>>)
  end
end
