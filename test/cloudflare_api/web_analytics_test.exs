defmodule CloudflareApi.WebAnalyticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WebAnalytics

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  @cases [
    %{
      fun: :create_site,
      args: ["acc", %{"hostname" => "example.com"}],
      method: :post,
      path: "/accounts/acc/rum/site_info",
      body: %{"hostname" => "example.com"}
    },
    %{
      fun: :list_sites,
      args: ["acc", [order_by: "created_on"]],
      method: :get,
      path: "/accounts/acc/rum/site_info/list?order_by=created_on"
    },
    %{
      fun: :get_site,
      args: ["acc", "site"],
      method: :get,
      path: "/accounts/acc/rum/site_info/site"
    },
    %{
      fun: :update_site,
      args: ["acc", "site", %{"hostname" => "example.com"}],
      method: :put,
      path: "/accounts/acc/rum/site_info/site",
      body: %{"hostname" => "example.com"}
    },
    %{
      fun: :delete_site,
      args: ["acc", "site"],
      method: :delete,
      path: "/accounts/acc/rum/site_info/site"
    },
    %{
      fun: :create_rule,
      args: ["acc", "ruleset", %{"expression" => "ip.src"}],
      method: :post,
      path: "/accounts/acc/rum/v2/ruleset/rule",
      body: %{"expression" => "ip.src"}
    },
    %{
      fun: :delete_rule,
      args: ["acc", "ruleset", "rule1"],
      method: :delete,
      path: "/accounts/acc/rum/v2/ruleset/rule/rule1"
    },
    %{
      fun: :update_rule,
      args: ["acc", "ruleset", "rule1", %{"status" => "active"}],
      method: :put,
      path: "/accounts/acc/rum/v2/ruleset/rule/rule1",
      body: %{"status" => "active"}
    },
    %{
      fun: :list_rules,
      args: ["acc", "ruleset"],
      method: :get,
      path: "/accounts/acc/rum/v2/ruleset/rules"
    },
    %{
      fun: :modify_rules,
      args: ["acc", "ruleset", %{"rules" => []}],
      method: :post,
      path: "/accounts/acc/rum/v2/ruleset/rules",
      body: %{"rules" => []}
    },
    %{
      fun: :get_rum_status,
      args: ["zone"],
      method: :get,
      path: "/zones/zone/settings/rum"
    },
    %{
      fun: :toggle_rum,
      args: ["zone", %{"value" => "on"}],
      method: :patch,
      path: "/zones/zone/settings/rum",
      body: %{"value" => "on"}
    }
  ]

  for %{fun: fun, args: args, method: method, path: path} = entry <- @cases do
    body = Map.get(entry, :body, :no_body)

    test "#{fun} hits #{path}", %{client: client} do
      mock(fn %Tesla.Env{method: unquote(method), url: url} = env ->
        assert url == @base <> unquote(path)

        case unquote(Macro.escape(body)) do
          :no_body -> :ok
          expected -> assert Jason.decode!(env.body) == expected
        end

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
      end)

      assert {:ok, %{"ok" => true}} =
               apply(WebAnalytics, unquote(fun), [client | unquote(Macro.escape(args))])
    end
  end

  test "bubbles rule errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 2000}]}}}
    end)

    assert {:error, [%{"code" => 2000}]} =
             WebAnalytics.create_rule(client, "acc", "ruleset", %{"expression" => ""})
  end
end
