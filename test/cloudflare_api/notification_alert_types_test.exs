defmodule CloudflareApi.NotificationAlertTypesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationAlertTypes

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches alert types", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/available_alerts"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "zone.down"}]}}}
    end)

    assert {:ok, [%{"id" => "zone.down"}]} = NotificationAlertTypes.list(client, "acc")
  end

  test "list/3 returns {:error, errors} on CF errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:error, [%{"code" => 42}]} = NotificationAlertTypes.list(client, "acc")
  end
end
