defmodule CloudflareApi.PpcConfigTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PpcConfig

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_config/2 hits the zone path", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/zones/zone-1/pay-per-crawl/configuration"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = PpcConfig.get_config(client, "zone-1")
  end

  test "create_config/3 posts JSON", %{client: client} do
    payload = %{"enabled" => true, "price_usd_microcents" => 1000}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/zones/zone-1/pay-per-crawl/configuration"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = PpcConfig.create_config(client, "zone-1", payload)
  end

  test "patch_config/3 patches JSON", %{client: client} do
    payload = %{"bot_overrides" => %{"friendly" => %{"mode" => "allow"}}}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) == "/zones/zone-1/pay-per-crawl/configuration"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = PpcConfig.patch_config(client, "zone-1", payload)
  end

  test "query_zones_can_be_enabled/3 posts payload", %{client: client} do
    payload = %{"zones" => [%{"id" => "zone-1"}]}
    response = %{"zones" => [%{"id" => "zone-1", "can_be_enabled" => true}]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/pay-per-crawl/zones_can_be_enabled/query"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => response}}}
    end)

    assert {:ok, ^response} =
             PpcConfig.query_zones_can_be_enabled(client, "acc", payload)
  end

  test "set_zones_can_be_enabled/3 patches payload", %{client: client} do
    payload = %{"zones" => [%{"id" => "zone-1", "can_be_enabled" => true}]}
    body = %{"success" => true, "errors" => [], "messages" => []}

    mock(fn %Tesla.Env{method: :patch, body: body_json} = env ->
      assert url(env) == "/accounts/acc/pay-per-crawl/zones_can_be_enabled"
      assert Jason.decode!(body_json) == payload
      {:ok, %Tesla.Env{env | status: 200, body: body}}
    end)

    assert {:ok, ^body} = PpcConfig.set_zones_can_be_enabled(client, "acc", payload)
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1000}]}}}
    end)

    assert {:error, [_]} = PpcConfig.get_config(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
