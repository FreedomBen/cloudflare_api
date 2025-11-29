defmodule CloudflareApi.DnsAnalyticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DnsAnalytics

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "report/3 encodes metrics opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/dns_analytics/report?metrics=queryCount&dimensions=queryName"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"totals" => []}}}}
    end)

    assert {:ok, %{"totals" => []}} =
             DnsAnalytics.report(client, "zone", metrics: "queryCount", dimensions: "queryName")
  end

  test "report_by_time/3 adds /bytime path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/dns_analytics/report/bytime?time_delta=1h"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"series" => []}}}}
    end)

    assert {:ok, %{"series" => []}} =
             DnsAnalytics.report_by_time(client, "zone", time_delta: "1h")
  end

  test "report/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1003}]}}}
    end)

    assert {:error, [%{"code" => 1003}]} = DnsAnalytics.report(client, "zone", [])
  end
end
