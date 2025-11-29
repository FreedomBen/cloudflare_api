defmodule CloudflareApi.NotificationMechanismEligibilityTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationMechanismEligibility

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches eligibility data", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/destinations/eligible?type=pagerduty"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"pagerduty" => true}}}}
    end)

    assert {:ok, %{"pagerduty" => true}} =
             NotificationMechanismEligibility.get(client, "acc", type: "pagerduty")
  end

  test "get/3 handles API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = NotificationMechanismEligibility.get(client, "acc")
  end
end
