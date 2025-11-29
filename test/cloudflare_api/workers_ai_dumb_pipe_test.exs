defmodule CloudflareApi.WorkersAiDumbPipeTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiDumbPipe

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "websocket_run_cf_pipecat_ai_smart_turn_v2/2 hits V2 endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/ai/run/@cf/pipecat-ai/smart-turn-v2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersAiDumbPipe.websocket_run_cf_pipecat_ai_smart_turn_v2(client, "acc")
  end

  test "websocket_run_cf_pipecat_ai_smart_turn_v3/2 hits V3 endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/ai/run/@cf/pipecat-ai/smart-turn-v3"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             WorkersAiDumbPipe.websocket_run_cf_pipecat_ai_smart_turn_v3(client, "acc")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} =
             WorkersAiDumbPipe.websocket_run_cf_pipecat_ai_smart_turn_v2(client, "acc")
  end
end
