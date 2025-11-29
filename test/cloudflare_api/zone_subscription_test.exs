defmodule CloudflareApi.ZoneSubscriptionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneSubscription

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches subscription details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/subscription"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "sub"}}}}
    end)

    assert {:ok, %{"id" => "sub"}} = ZoneSubscription.get(client, "zone")
  end

  test "create/3 and update/3 send JSON bodies", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/subscription"
        assert Jason.decode!(body) == %{"rate_plan" => %{"id" => "pro"}}

        {:ok,
         %Tesla.Env{env | status: 200, body: %{"result" => %{"rate_plan" => %{"id" => "pro"}}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/subscription"
        assert Jason.decode!(body) == %{"rate_plan" => %{"id" => "biz"}}

        {:ok,
         %Tesla.Env{env | status: 200, body: %{"result" => %{"rate_plan" => %{"id" => "biz"}}}}}
    end)

    assert {:ok, %{"rate_plan" => %{"id" => "pro"}}} =
             ZoneSubscription.create(client, "zone", %{"rate_plan" => %{"id" => "pro"}})

    assert {:ok, %{"rate_plan" => %{"id" => "biz"}}} =
             ZoneSubscription.update(client, "zone", %{"rate_plan" => %{"id" => "biz"}})
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 402, body: %{"errors" => [%{"code" => 9001}]}}}
    end)

    assert {:error, [%{"code" => 9001}]} =
             ZoneSubscription.create(client, "zone", %{"rate_plan" => %{}})
  end
end
