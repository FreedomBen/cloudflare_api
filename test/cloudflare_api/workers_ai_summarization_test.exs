defmodule CloudflareApi.WorkersAiSummarizationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiSummarization

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "run_cf_facebook_bart_large_cnn/4 posts JSON", %{client: client} do
    params = %{"text" => "Large input"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/run/@cf/facebook/bart-large-cnn?tags=sum"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"summary" => "Short"}}}}
    end)

    assert {:ok, %{"summary" => "Short"}} =
             WorkersAiSummarization.run_cf_facebook_bart_large_cnn(
               client,
               "acc",
               params,
               tags: "sum"
             )
  end

  test "run_cf_facebook_omni_bart_large_cnn/4 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 15}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiSummarization.run_cf_facebook_omni_bart_large_cnn(client, "acc", %{})
  end
end
