defmodule CloudflareApi.AccountLoadBalancerMonitorGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountLoadBalancerMonitorGroups

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/monitor_groups?per_page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "grp"}]}}}
    end)

    assert {:ok, [_]} =
             AccountLoadBalancerMonitorGroups.list(client, "acc", per_page: 2)
  end

  test "update/4 sends JSON", %{client: client} do
    params = %{"name" => "Group"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             AccountLoadBalancerMonitorGroups.update(client, "acc", "grp", params)
  end

  test "list_references/3 hits references endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/monitor_groups/grp/references"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = AccountLoadBalancerMonitorGroups.list_references(client, "acc", "grp")
  end
end
