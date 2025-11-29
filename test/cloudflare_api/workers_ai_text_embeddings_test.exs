defmodule CloudflareApi.WorkersAiTextEmbeddingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiTextEmbeddings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  for {fun, model} <- WorkersAiTextEmbeddings.run_models() do
    test "#{fun} runs #{model}", %{client: client} do
      body = %{"text" => "hello"}

      mock(fn %Tesla.Env{method: :post, url: url, body: req_body} = env ->
        assert url ==
                 @base <> "/accounts/acc/ai/run/#{unquote(model)}?queueRequest=true"

        assert Jason.decode!(req_body) == body
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "job"}}}}
      end)

      assert {:ok, %{"id" => "job"}} =
               apply(WorkersAiTextEmbeddings, unquote(fun), [
                 client,
                 "acc",
                 body,
                 [queueRequest: true]
               ])
    end
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiTextEmbeddings.run_cf_baai_bge_base_en_v1_5(client, "acc", %{})
  end
end
