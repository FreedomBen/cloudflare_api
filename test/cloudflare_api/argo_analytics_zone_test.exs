defmodule CloudflareApi.ArgoAnalyticsZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ArgoAnalyticsZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/analytics/latency?since=1h"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"latency" => 50}]}}}
    end)

    assert {:ok, [%{"latency" => 50}]} = ArgoAnalyticsZone.list(client, "zone", since: "1h")
  end

  test "list/3 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 1234, "message" => "invalid zone"}]}
       }}
    end)

    assert {:error, [%{"code" => 1234, "message" => "invalid zone"}]} =
             ArgoAnalyticsZone.list(client, "zone")
  end
end
