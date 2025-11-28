defmodule CloudflareApi.AiGatewayProviderConfigsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AiGatewayProviderConfigs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/provider_configs?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cfg"}]}}}
    end)

    assert {:ok, [%{"id" => "cfg"}]} =
             AiGatewayProviderConfigs.list(client, "acc", "gw", page: 1)
  end

  test "create/4 sends params", %{client: client} do
    params = %{"provider" => "openai"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             AiGatewayProviderConfigs.create(client, "acc", "gw", params)
  end

  test "update/5 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} =
             AiGatewayProviderConfigs.update(client, "acc", "gw", "cfg", %{})
  end
end
