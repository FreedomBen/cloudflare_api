defmodule CloudflareApi.WorkersAiTextGenerationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiTextGeneration

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  for {fun, model} <- WorkersAiTextGeneration.run_models() do
    test "#{fun} targets #{model}", %{client: client} do
      params = %{"messages" => [%{"role" => "user", "content" => "hi"}]}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url ==
                 @base <> "/accounts/acc/ai/run/#{unquote(model)}?tags=demo"

        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"output" => "ok"}}}}
      end)

      assert {:ok, %{"output" => "ok"}} =
               apply(WorkersAiTextGeneration, unquote(fun), [
                 client,
                 "acc",
                 params,
                 [tags: "demo"]
               ])
    end
  end

  test "bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiTextGeneration.run_cf_google_gemma_3_12b_it(client, "acc", %{})
  end
end
