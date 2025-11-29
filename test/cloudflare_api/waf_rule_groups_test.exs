defmodule CloudflareApi.WafRuleGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WafRuleGroups

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes package path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/waf/packages/pkg/groups?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "group"}]}}}
    end)

    assert {:ok, [%{"id" => "group"}]} =
             WafRuleGroups.list(client, "zone", "pkg", page: 1)
  end

  test "update/5 patches body", %{client: client} do
    params = %{"mode" => "disable"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             WafRuleGroups.update(client, "zone", "pkg", "group", params)
  end
end
