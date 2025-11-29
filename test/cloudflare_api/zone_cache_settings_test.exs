defmodule CloudflareApi.ZoneCacheSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneCacheSettings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_cache_reserve/2 fetches reserve settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/cache/cache_reserve"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "off"}}}}
    end)

    assert {:ok, %{"value" => "off"}} =
             ZoneCacheSettings.get_cache_reserve(client, "zone")
  end

  test "patch_cache_reserve/3 sends JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) == "/zones/zone/cache/cache_reserve"
      assert Jason.decode!(body) == %{"value" => "on"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}
    end)

    assert {:ok, %{"value" => "on"}} =
             ZoneCacheSettings.patch_cache_reserve(client, "zone", %{"value" => "on"})
  end

  test "cache_reserve_clear endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/cache/cache_reserve_clear"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "pending"}}}}
    end)

    assert {:ok, %{"status" => "pending"}} =
             ZoneCacheSettings.get_cache_reserve_clear(client, "zone")

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == @base <> "/zones/zone/cache/cache_reserve_clear"
      assert Jason.decode!(body) == %{"action" => "start"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZoneCacheSettings.start_cache_reserve_clear(client, "zone", %{"action" => "start"})
  end

  test "regional tiered cache endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/cache/regional_tiered_cache"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}
    end)

    assert {:ok, %{"value" => "on"}} =
             ZoneCacheSettings.get_regional_tiered_cache(client, "zone")

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == @base <> "/zones/zone/cache/regional_tiered_cache"
      assert Jason.decode!(body) == %{"value" => "off"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "off"}}}}
    end)

    assert {:ok, %{"value" => "off"}} =
             ZoneCacheSettings.patch_regional_tiered_cache(client, "zone", %{"value" => "off"})
  end

  test "variant endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/cache/variants"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = ZoneCacheSettings.get_variants(client, "zone")

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == @base <> "/zones/zone/cache/variants"
      assert Jason.decode!(body) == %{"value" => []}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZoneCacheSettings.patch_variants(client, "zone", %{"value" => []})

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == @base <> "/zones/zone/cache/variants"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = ZoneCacheSettings.delete_variants(client, "zone")
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [_]} = ZoneCacheSettings.get_cache_reserve(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
