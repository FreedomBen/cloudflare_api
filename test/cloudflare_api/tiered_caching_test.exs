defmodule CloudflareApi.TieredCachingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TieredCaching

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches tiered caching settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/argo/tiered_caching"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}
    end)

    assert {:ok, %{"value" => "on"}} = TieredCaching.get(client, "zone")
  end

  test "update/3 posts payload", %{client: client} do
    params = %{"value" => "off"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = TieredCaching.update(client, "zone", params)
  end
end
