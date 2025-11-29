defmodule CloudflareApi.WorkersAiTextClassificationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiTextClassification

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  @cases [
    %{
      fun: :run_cf_baai_bge_reranker_base,
      model_path: "@cf/baai/bge-reranker-base"
    },
    %{
      fun: :run_cf_huggingface_distilbert_sst2_int8,
      model_path: "@cf/huggingface/distilbert-sst-2-int8"
    },
    %{
      fun: :run_cf_huggingface_omni_distilbert_sst2_int8,
      model_path: "@cf/huggingface/omni-distilbert-sst-2-int8"
    }
  ]

  for %{fun: fun, model_path: model_path} <- @cases do
    test "#{fun} posts JSON to #{model_path}", %{client: client} do
      params = %{"inputs" => ["Great product!"]}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url ==
                 @base <> "/accounts/acc/ai/run/#{unquote(model_path)}?queueRequest=true"

        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"score" => 0.9}]}}}
      end)

      assert {:ok, [_]} =
               apply(
                 WorkersAiTextClassification,
                 unquote(fun),
                 [client, "acc", params, [queueRequest: true]]
               )
    end
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 19}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiTextClassification.run_cf_baai_bge_reranker_base(client, "acc", %{})
  end
end
