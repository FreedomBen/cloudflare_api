defmodule CloudflareApi.SecurityCenterInsightsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecurityCenterInsights

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_attack_surface_issues/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/attack-surface-report/issues?severity=high"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"issues" => []}}}}
    end)

    assert {:ok, %{"issues" => []}} =
             SecurityCenterInsights.list_attack_surface_issues(client, "acc", severity: "high")
  end

  test "attack_surface_counts_by_class/3 handles special query keys", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url =~ "issue_type~neq=attack"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"counts" => []}}}}
    end)

    assert {:ok, %{"counts" => []}} =
             SecurityCenterInsights.attack_surface_counts_by_class(
               client,
               "acc",
               [{:"issue_type~neq", "attack"}]
             )
  end

  test "dismiss_attack_surface_issue/4 posts dismiss flag", %{client: client} do
    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == %{"dismiss" => false}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"dismissed" => false}}}}
    end)

    assert {:ok, %{"dismissed" => false}} =
             SecurityCenterInsights.dismiss_attack_surface_issue(
               client,
               "acc",
               "issue",
               %{"dismiss" => false}
             )
  end

  test "list_insights/3 encodes pagination", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/security-center/insights?page=2&per_page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"issues" => []}}}}
    end)

    assert {:ok, %{"issues" => []}} =
             SecurityCenterInsights.list_insights(client, "acc", page: 2, per_page: 1)
  end

  test "dismiss_zone_insight/4 encodes zone path", %{client: client} do
    mock(fn %Tesla.Env{url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/security-center/insights/abc%2F123/dismiss"

      assert Jason.decode!(body) == %{"dismiss" => true}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"dismissed" => true}}}}
    end)

    assert {:ok, %{"dismissed" => true}} =
             SecurityCenterInsights.dismiss_zone_insight(client, "zone", "abc/123")
  end

  test "list_issue_types/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 500}]}}}
    end)

    assert {:error, [%{"code" => 500}]} =
             SecurityCenterInsights.list_issue_types(client, "acc")
  end
end
