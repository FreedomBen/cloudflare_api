defmodule CloudflareApi.RealtimeKitAppsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RealtimeKitApps

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits apps endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/apps"} =
              env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "app"}]}}}
    end)

    assert {:ok, [_]} = RealtimeKitApps.list(client, "acc")
  end
end
