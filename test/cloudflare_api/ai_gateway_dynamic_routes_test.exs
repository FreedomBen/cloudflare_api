defmodule CloudflareApi.AiGatewayDynamicRoutesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AiGatewayDynamicRoutes

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/routes?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "route"}]}}}
    end)

    assert {:ok, [%{"id" => "route"}]} =
             AiGatewayDynamicRoutes.list(client, "acc", "gw", page: 2)
  end

  test "list_deployments/5 hits deployments endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/routes/route/deployments"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"state" => "success"}]}}}
    end)

    assert {:ok, [%{"state" => "success"}]} =
             AiGatewayDynamicRoutes.list_deployments(client, "acc", "gw", "route")
  end

  test "create_version/5 sends JSON body", %{client: client} do
    params = %{"notes" => "deploy"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/routes/route/versions"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"notes" => "deploy"}}}}
    end)

    assert {:ok, %{"notes" => "deploy"}} =
             AiGatewayDynamicRoutes.create_version(client, "acc", "gw", "route", params)
  end

  test "update/5 bubbles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/routes/route"

      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 9000}]}}}
    end)

    assert {:error, [%{"code" => 9000}]} =
             AiGatewayDynamicRoutes.update(client, "acc", "gw", "route", %{})
  end
end
