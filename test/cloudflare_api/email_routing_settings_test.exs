defmodule CloudflareApi.EmailRoutingSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EmailRoutingSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_settings/2 fetches settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/email/routing"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             EmailRoutingSettings.get_settings(client, "zone")
  end

  test "enable/2 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/email/routing/enable"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             EmailRoutingSettings.enable(client, "zone")
  end

  test "disable_dns/2 sends delete with empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"dns_records_removed" => true}}}}
    end)

    assert {:ok, %{"dns_records_removed" => true}} =
             EmailRoutingSettings.disable_dns(client, "zone")
  end

  test "unlock_dns/3 posts patch body", %{client: client} do
    params = %{"locked" => false}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/email/routing/dns"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             EmailRoutingSettings.unlock_dns(client, "zone", params)
  end

  test "dns_settings/2 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 502, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             EmailRoutingSettings.dns_settings(client, "zone")
  end
end
