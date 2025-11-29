defmodule CloudflareApi.ZoneSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneSettings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_all/2 and update_all/3 call the bulk settings endpoints", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/settings"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "always_online"}]}}}

      %Tesla.Env{method: :patch, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/settings"
        assert Jason.decode!(body) == %{"items" => []}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, [%{"id" => "always_online"}]} = ZoneSettings.get_all(client, "zone")
    assert {:ok, []} = ZoneSettings.update_all(client, "zone", %{"items" => []})
  end

  test "single-setting helpers cover flexible IDs", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/settings/cache_level"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cache_level"}}}}

      %Tesla.Env{method: :patch, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/settings/cache_level"
        assert Jason.decode!(body) == %{"value" => "simplified"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "simplified"}}}}
    end)

    assert {:ok, %{"id" => "cache_level"}} =
             ZoneSettings.get_setting(client, "zone", "cache_level")

    assert {:ok, %{"value" => "simplified"}} =
             ZoneSettings.update_setting(client, "zone", "cache_level", %{"value" => "simplified"})
  end

  test "specialized helpers resolve to the right IDs", %{client: client} do
    mock(fn
      %Tesla.Env{method: :patch, url: url} = env ->
        assert url == @base <> "/zones/zone/settings/aegis"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "on"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/settings/speed_brain"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"value" => "off"}}}}
    end)

    assert {:ok, %{"value" => "on"}} =
             ZoneSettings.patch_aegis(client, "zone", %{"value" => "on"})

    assert {:ok, %{"value" => "off"}} = ZoneSettings.get_speed_brain(client, "zone")
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9999}]}}}
    end)

    assert {:error, [%{"code" => 9999}]} = ZoneSettings.get_all(client, "zone")
  end
end
