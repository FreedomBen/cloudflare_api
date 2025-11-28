defmodule CloudflareApi.AiGatewayGatewaysTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AiGatewayGateways

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "gw"}]}}}
    end)

    assert {:ok, [%{"id" => "gw"}]} = AiGatewayGateways.list(client, "acc", per_page: 5)
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"name" => "gateway"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "gw"}}}}
    end)

    assert {:ok, %{"id" => "gw"}} = AiGatewayGateways.create(client, "acc", params)
  end

  test "update/4 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: _} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 2222}]}}}
    end)

    assert {:error, [%{"code" => 2222}]} = AiGatewayGateways.update(client, "acc", "gw", %{})
  end

  test "provider_url/4 hits provider endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/url/openai"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"url" => "https://example"}}}}
    end)

    assert {:ok, %{"url" => "https://example"}} =
             AiGatewayGateways.provider_url(client, "acc", "gw", "openai")
  end
end
