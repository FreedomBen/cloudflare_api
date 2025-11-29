defmodule CloudflareApi.SmartTieredCacheTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SmartTieredCache

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches tiered cache settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/cache/tiered_cache_smart_topology_enable"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}
    end)

    assert {:ok, %{"value" => "on"}} = SmartTieredCache.get(client, "zone")
  end

  test "update/3 sends JSON body", %{client: client} do
    params = %{"value" => "off"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SmartTieredCache.update(client, "zone", params)
  end

  test "delete/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 1142}]}}}
    end)

    assert {:error, [%{"code" => 1142}]} = SmartTieredCache.delete(client, "zone")
  end
end
