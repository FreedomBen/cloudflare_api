defmodule CloudflareApi.NotificationHistoryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationHistory

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches alert history", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/history?page=3"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "evt"}]}}}
    end)

    assert {:ok, [%{"id" => "evt"}]} = NotificationHistory.list(client, "acc", page: 3)
  end

  test "list/3 bubbles up Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 5001}]}}}
    end)

    assert {:error, [%{"code" => 5001}]} = NotificationHistory.list(client, "acc")
  end
end
