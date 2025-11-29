defmodule CloudflareApi.WorkersAiTextToImageTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiTextToImage

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  for {fun, model} <- WorkersAiTextToImage.run_models() do
    test "#{fun} posts to #{model}", %{client: client} do
      params = %{"prompt" => "sunset skyline"}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url ==
                 @base <> "/accounts/acc/ai/run/#{unquote(model)}?queueRequest=true"

        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"image" => "b64"}}}}
      end)

      assert {:ok, %{"image" => "b64"}} =
               apply(WorkersAiTextToImage, unquote(fun), [
                 client,
                 "acc",
                 params,
                 [queueRequest: true]
               ])
    end
  end

  for {fun, model} <- WorkersAiTextToImage.websocket_models() do
    test "#{fun} opens websocket #{model}", %{client: client} do
      mock(fn %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/accounts/acc/ai/run/#{unquote(model)}"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} = apply(WorkersAiTextToImage, unquote(fun), [client, "acc"])
    end
  end

  test "reports errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 7}]}}}
    end)

    assert {:error, [_]} =
             WorkersAiTextToImage.run_cf_black_forest_labs_flux_1_schnell(
               client,
               "acc",
               %{"prompt" => "test"}
             )
  end
end
