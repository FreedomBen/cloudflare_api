defmodule CloudflareApi.RealtimeKitActiveSessionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RealtimeKitActiveSession

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/4 hits session endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/meeting/active-session"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "LIVE"}}}}
    end)

    assert {:ok, %{"status" => "LIVE"}} =
             RealtimeKitActiveSession.get(client, "acc", "app", "meeting")
  end

  test "kick/5 posts payload", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/meeting/active-session/kick"

      assert Jason.decode!(body) == %{"participants" => ["user"]}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"kicked" => 1}}}}
    end)

    assert {:ok, %{"kicked" => 1}} =
             RealtimeKitActiveSession.kick(client, "acc", "app", "meeting", %{
               "participants" => ["user"]
             })
  end
end
