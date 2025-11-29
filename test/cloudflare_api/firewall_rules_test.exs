defmodule CloudflareApi.FirewallRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.FirewallRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 forwards filters to query params", %{client: client} do
    opts = [action: "block", description: "login", id: "abc", page: 2, paused: true, per_page: 50]

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/rules" <>
                 "?action=block&description=login&id=abc&page=2&paused=true&per_page=50"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "abc"}]}}}
    end)

    assert {:ok, [%{"id" => "abc"}]} = FirewallRules.list(client, "zone", opts)
  end

  test "create/3 wraps single map payload into a list", %{client: client} do
    rule = %{"action" => "block", "filter" => %{"expression" => "ip.src eq 1.1.1.1"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == [rule]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [rule]}}}
    end)

    assert {:ok, [^rule]} = FirewallRules.create(client, "zone", rule)
  end

  test "update_many/3 sends list payload", %{client: client} do
    payload = [%{"id" => "rule-1", "action" => "block"}]

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = FirewallRules.update_many(client, "zone", payload)
  end

  test "update_priorities/3 uses PATCH for bulk updates", %{client: client} do
    payload = %{"id" => "rule-1", "priority" => 5}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == [payload]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [payload]}}}
    end)

    assert {:ok, [^payload]} = FirewallRules.update_priorities(client, "zone", payload)
  end

  test "delete_many/4 builds id objects and applies delete flag", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == [
               %{"id" => "r1", "delete_filter_if_unused" => true},
               %{"id" => "r2", "delete_filter_if_unused" => true}
             ]

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "r1"}]}}}
    end)

    assert {:ok, [%{"id" => "r1"}]} =
             FirewallRules.delete_many(client, "zone", ["r1", "r2"],
               delete_filter_if_unused: true
             )
  end

  test "delete_many/4 errors when ids missing", %{client: client} do
    assert {:error, :missing_rule_id} = FirewallRules.delete_many(client, "zone", [%{}])
  end

  test "get/4 fetches a single rule and appends query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/rules/rule-1?id=rule-1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule-1"}}}}
    end)

    assert {:ok, %{"id" => "rule-1"}} = FirewallRules.get(client, "zone", "rule-1", id: "rule-1")
  end

  test "update/4 injects the rule id", %{client: client} do
    params = %{"action" => "allow"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == %{"action" => "allow", "id" => "rule-1"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule-1"}}}}
    end)

    assert {:ok, %{"id" => "rule-1"}} = FirewallRules.update(client, "zone", "rule-1", params)
  end

  test "update_priority/4 injects the rule id", %{client: client} do
    params = %{"priority" => 10}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == %{"id" => "rule-1", "priority" => 10}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule-1"}}}}
    end)

    assert {:ok, %{"id" => "rule-1"}} =
             FirewallRules.update_priority(client, "zone", "rule-1", params)
  end

  test "delete/4 passes delete_filter_if_unused body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{"delete_filter_if_unused" => true}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule-1"}}}}
    end)

    assert {:ok, %{"id" => "rule-1"}} =
             FirewallRules.delete(client, "zone", "rule-1", delete_filter_if_unused: true)
  end

  test "handle_response/1 returns API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = FirewallRules.list(client, "zone")
  end
end
