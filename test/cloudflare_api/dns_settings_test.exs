defmodule CloudflareApi.DnsSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DnsSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "zone_settings/2 fetches zone DNS settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/dns_settings"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"zone_defaults" => %{}}}}}
    end)

    assert {:ok, %{"zone_defaults" => %{}}} = DnsSettings.zone_settings(client, "zone")
  end

  test "update_zone_settings/3 posts JSON body", %{client: client} do
    params = %{"zone_defaults" => %{"ipv6" => false}}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/dns_settings"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = DnsSettings.update_zone_settings(client, "zone", params)
  end

  test "account_settings/2 fetches account settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_settings"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = DnsSettings.account_settings(client, "acc")
  end

  test "update_account_settings/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [%{"code" => 10}]} =
             DnsSettings.update_account_settings(client, "acc", %{"dnssec" => "off"})
  end
end
