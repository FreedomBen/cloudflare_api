defmodule CloudflareApi.ArgoAnalyticsGeolocationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ArgoAnalyticsGeolocation

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_colos/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/analytics/latency/colos?per_page=3"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"colo_id" => "SJC"}]}}}
    end)

    assert {:ok, [_]} = ArgoAnalyticsGeolocation.list_colos(client, "zone", per_page: 3)
  end
end
