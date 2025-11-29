defmodule CloudflareApi.DnsFirewallAnalyticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DnsFirewallAnalytics

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "report/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_firewall/cluster/dns_analytics/report?metrics=queryCount"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"totals" => []}}}}
    end)

    assert {:ok, %{"totals" => []}} =
             DnsFirewallAnalytics.report(client, "acc", "cluster", metrics: "queryCount")
  end

  test "report_by_time/4 hits bytime endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_firewall/cluster/dns_analytics/report/bytime?time_delta=30m"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"series" => []}}}}
    end)

    assert {:ok, %{"series" => []}} =
             DnsFirewallAnalytics.report_by_time(client, "acc", "cluster", time_delta: "30m")
  end

  test "report/4 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 123}]}}}
    end)

    assert {:error, [%{"code" => 123}]} =
             DnsFirewallAnalytics.report(client, "acc", "cluster", [])
  end
end
