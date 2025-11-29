defmodule CloudflareApi.WorkersAiTextToSpeechTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiTextToSpeech

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  for {fun, model} <- WorkersAiTextToSpeech.run_models() do
    test "#{fun} posts to #{model}", %{client: client} do
      params = %{"text" => "Hello world"}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/accounts/acc/ai/run/#{unquote(model)}"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"audio" => "b64"}}}}
      end)

      assert {:ok, %{"audio" => "b64"}} =
               apply(WorkersAiTextToSpeech, unquote(fun), [client, "acc", params, []])
    end
  end

  for {fun, model} <- WorkersAiTextToSpeech.websocket_models() do
    test "#{fun} opens websocket #{model}", %{client: client} do
      mock(fn %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/accounts/acc/ai/run/#{unquote(model)}"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} =
               apply(WorkersAiTextToSpeech, unquote(fun), [client, "acc"])
    end
  end

  test "run_cf_myshell_ai_melotts bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 17}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiTextToSpeech.run_cf_myshell_ai_melotts(
               client,
               "acc",
               %{"prompt" => "hi"}
             )
  end
end
