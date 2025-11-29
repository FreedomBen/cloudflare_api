defmodule CloudflareApi.SpectrumAnalyticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SpectrumAnalytics

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "aggregate_current/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/spectrum/analytics/aggregate/current?appID=abc&colo_name=PDX"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"requestCount" => 10}}}}
    end)

    assert {:ok, %{"requestCount" => 10}} =
             SpectrumAnalytics.aggregate_current(client, "zone",
               appID: "abc",
               colo_name: "PDX"
             )
  end

  test "events_by_time/3 requires opts and passes them through", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/spectrum/analytics/events/bytime?time_delta=minute&metrics=requests"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"sum" => 5}]}}}
    end)

    assert {:ok, [%{"sum" => 5}]} =
             SpectrumAnalytics.events_by_time(client, "zone",
               time_delta: "minute",
               metrics: "requests"
             )
  end

  test "events_summary/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1005}]}}}
    end)

    assert {:error, [%{"code" => 1005}]} =
             SpectrumAnalytics.events_summary(client, "zone", filters: "colo_name==\"PDX\"")
  end
end
