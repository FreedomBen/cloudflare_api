defmodule CloudflareApi.WorkersAiImageClassificationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiImageClassification

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "run_cf_microsoft_resnet_50/4 posts binary body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/ai/run/@cf/microsoft/resnet-50?tags=cat"

      assert body == <<1, 2, 3>>
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"label" => "cat"}}}}
    end)

    assert {:ok, %{"label" => "cat"}} =
             WorkersAiImageClassification.run_cf_microsoft_resnet_50(
               client,
               "acc",
               <<1, 2, 3>>,
               tags: "cat"
             )
  end

  test "propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiImageClassification.run_cf_microsoft_resnet_50(client, "acc", <<>>)
  end
end
