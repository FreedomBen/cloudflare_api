defmodule CloudflareApi.RealtimeKitAnalyticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RealtimeKitAnalytics

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "daywise/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/analytics/daywise?per_page=7"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"sessions" => 1}]}}}
    end)

    assert {:ok, [_]} = RealtimeKitAnalytics.daywise(client, "acc", "app", per_page: 7)
  end
end
