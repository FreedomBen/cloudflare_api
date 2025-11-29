defmodule CloudflareApi.WorkersAiObjectDetectionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiObjectDetection

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "run_cf_facebook_omni_detr_resnet_50/4 posts binary body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/run/@cf/facebook/omni-detr-resnet-50?queueRequest=true"

      assert body == <<4, 5, 6>>
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"label" => "car"}]}}}
    end)

    assert {:ok, [%{"label" => "car"}]} =
             WorkersAiObjectDetection.run_cf_facebook_omni_detr_resnet_50(
               client,
               "acc",
               <<4, 5, 6>>,
               queueRequest: true
             )
  end

  test "error bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 8}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiObjectDetection.run_cf_facebook_omni_detr_resnet_50(client, "acc", <<>>)
  end
end
