defmodule CloudflareApi.WorkersAiTranslationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiTranslation

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  for {fun, model} <- WorkersAiTranslation.run_models() do
    test "#{fun} hits #{model}", %{client: client} do
      params = %{"text" => "hello", "source_lang" => "en", "target_lang" => "es"}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url ==
                 @base <> "/accounts/acc/ai/run/#{unquote(model)}?queueRequest=true"

        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"translation" => "hola"}}}}
      end)

      assert {:ok, %{"translation" => "hola"}} =
               apply(WorkersAiTranslation, unquote(fun), [
                 client,
                 "acc",
                 params,
                 [queueRequest: true]
               ])
    end
  end

  test "handles translation errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 23}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiTranslation.run_cf_meta_m2m100_1_2b(client, "acc", %{"text" => "hi"})
  end
end
