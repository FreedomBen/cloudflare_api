defmodule CloudflareApi.DosFlowtrackdApiTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DosFlowtrackdApi

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "dns protection rule endpoints", %{client: client} do
    base = "/accounts/acct/magic/advanced_dns_protection/configs/dns_protection/rules"

    mock(fn %Tesla.Env{} = env ->
      path = rel(env)

      cond do
        env.method == :get and path == "#{base}?page=1" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == base ->
          assert Jason.decode!(env.body) == %{"action" => "block"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}

        env.method == :delete and path == base ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{base}/rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}

        env.method == :patch and path == "#{base}/rule" ->
          assert Jason.decode!(env.body) == %{"action" => "challenge"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"action" => "challenge"}}}}

        env.method == :delete and path == "#{base}/rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end
    end)

    assert {:ok, []} = DosFlowtrackdApi.list_dns_protection_rules(client, "acct", page: 1)

    assert {:ok, %{"id" => "rule"}} =
             DosFlowtrackdApi.create_dns_protection_rule(client, "acct", %{"action" => "block"})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_dns_protection_rules(client, "acct")

    assert {:ok, %{"id" => "rule"}} =
             DosFlowtrackdApi.get_dns_protection_rule(client, "acct", "rule")

    assert {:ok, %{"action" => "challenge"}} =
             DosFlowtrackdApi.update_dns_protection_rule(client, "acct", "rule", %{
               "action" => "challenge"
             })

    assert {:ok, %{}} = DosFlowtrackdApi.delete_dns_protection_rule(client, "acct", "rule")
  end

  test "allowlist and prefixes endpoints", %{client: client} do
    allowlist = "/accounts/acct/magic/advanced_tcp_protection/configs/allowlist"
    prefixes = "/accounts/acct/magic/advanced_tcp_protection/configs/prefixes"

    mock(fn %Tesla.Env{} = env ->
      path = rel(env)

      cond do
        env.method == :get and path == allowlist ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == allowlist ->
          assert Jason.decode!(env.body) == %{"prefix" => "1.1.1.0/24"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "allow"}}}}

        env.method == :delete and path == allowlist ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{allowlist}/allow" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "allow"}}}}

        env.method == :patch and path == "#{allowlist}/allow" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == "#{allowlist}/allow" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == prefixes ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == prefixes ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pref"}}}}

        env.method == :post and path == "#{prefixes}/bulk" ->
          assert Jason.decode!(env.body) == %{"items" => []}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == prefixes ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{prefixes}/pref" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pref"}}}}

        env.method == :patch and path == "#{prefixes}/pref" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == "#{prefixes}/pref" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end
    end)

    assert {:ok, []} = DosFlowtrackdApi.list_allowlist_prefixes(client, "acct")

    assert {:ok, %{"id" => "allow"}} =
             DosFlowtrackdApi.create_allowlist_prefix(client, "acct", %{"prefix" => "1.1.1.0/24"})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_allowlist_prefixes(client, "acct")

    assert {:ok, %{"id" => "allow"}} =
             DosFlowtrackdApi.get_allowlist_prefix(client, "acct", "allow")

    assert {:ok, %{}} =
             DosFlowtrackdApi.update_allowlist_prefix(client, "acct", "allow", %{
               "prefix" => "1.1.1.0/24"
             })

    assert {:ok, %{}} = DosFlowtrackdApi.delete_allowlist_prefix(client, "acct", "allow")

    assert {:ok, []} = DosFlowtrackdApi.list_prefixes(client, "acct")
    assert {:ok, %{"id" => "pref"}} = DosFlowtrackdApi.create_prefix(client, "acct", %{})
    assert {:ok, %{}} = DosFlowtrackdApi.bulk_create_prefixes(client, "acct", %{"items" => []})
    assert {:ok, %{}} = DosFlowtrackdApi.delete_prefixes(client, "acct")
    assert {:ok, %{"id" => "pref"}} = DosFlowtrackdApi.get_prefix(client, "acct", "pref")
    assert {:ok, %{}} = DosFlowtrackdApi.update_prefix(client, "acct", "pref", %{})
    assert {:ok, %{}} = DosFlowtrackdApi.delete_prefix(client, "acct", "pref")
  end

  test "syn/tcp flow filters, rules, and status", %{client: client} do
    syn_filters = "/accounts/acct/magic/advanced_tcp_protection/configs/syn_protection/filters"
    syn_rules = "/accounts/acct/magic/advanced_tcp_protection/configs/syn_protection/rules"

    tcp_flow_filters =
      "/accounts/acct/magic/advanced_tcp_protection/configs/tcp_flow_protection/filters"

    tcp_flow_rules =
      "/accounts/acct/magic/advanced_tcp_protection/configs/tcp_flow_protection/rules"

    status = "/accounts/acct/magic/advanced_tcp_protection/configs/tcp_protection_status"

    mock(fn %Tesla.Env{} = env ->
      path = rel(env)

      cond do
        env.method == :get and path == syn_filters ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == syn_filters ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "syn_filter"}}}}

        env.method == :delete and path == syn_filters ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{syn_filters}/syn_filter" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "syn_filter"}}}}

        env.method == :patch and path == "#{syn_filters}/syn_filter" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == "#{syn_filters}/syn_filter" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == syn_rules ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == syn_rules ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "syn_rule"}}}}

        env.method == :delete and path == syn_rules ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{syn_rules}/syn_rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "syn_rule"}}}}

        env.method == :patch and path == "#{syn_rules}/syn_rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == "#{syn_rules}/syn_rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == tcp_flow_filters ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == tcp_flow_filters ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "flow_filter"}}}}

        env.method == :delete and path == tcp_flow_filters ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{tcp_flow_filters}/flow_filter" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "flow_filter"}}}}

        env.method == :patch and path == "#{tcp_flow_filters}/flow_filter" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == "#{tcp_flow_filters}/flow_filter" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == tcp_flow_rules ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == tcp_flow_rules ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "flow_rule"}}}}

        env.method == :delete and path == tcp_flow_rules ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "#{tcp_flow_rules}/flow_rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "flow_rule"}}}}

        env.method == :patch and path == "#{tcp_flow_rules}/flow_rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :delete and path == "#{tcp_flow_rules}/flow_rule" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == status ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}

        env.method == :patch and path == status ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => false}}}}
      end
    end)

    assert {:ok, []} = DosFlowtrackdApi.list_syn_protection_filters(client, "acct")

    assert {:ok, %{"id" => "syn_filter"}} =
             DosFlowtrackdApi.create_syn_protection_filter(client, "acct", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_syn_protection_filters(client, "acct")

    assert {:ok, %{"id" => "syn_filter"}} =
             DosFlowtrackdApi.get_syn_protection_filter(client, "acct", "syn_filter")

    assert {:ok, %{}} =
             DosFlowtrackdApi.update_syn_protection_filter(client, "acct", "syn_filter", %{})

    assert {:ok, %{}} =
             DosFlowtrackdApi.delete_syn_protection_filter(client, "acct", "syn_filter")

    assert {:ok, []} = DosFlowtrackdApi.list_syn_protection_rules(client, "acct")

    assert {:ok, %{"id" => "syn_rule"}} =
             DosFlowtrackdApi.create_syn_protection_rule(client, "acct", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_syn_protection_rules(client, "acct")

    assert {:ok, %{"id" => "syn_rule"}} =
             DosFlowtrackdApi.get_syn_protection_rule(client, "acct", "syn_rule")

    assert {:ok, %{}} =
             DosFlowtrackdApi.update_syn_protection_rule(client, "acct", "syn_rule", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_syn_protection_rule(client, "acct", "syn_rule")

    assert {:ok, []} = DosFlowtrackdApi.list_tcp_flow_filters(client, "acct")

    assert {:ok, %{"id" => "flow_filter"}} =
             DosFlowtrackdApi.create_tcp_flow_filter(client, "acct", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_tcp_flow_filters(client, "acct")

    assert {:ok, %{"id" => "flow_filter"}} =
             DosFlowtrackdApi.get_tcp_flow_filter(client, "acct", "flow_filter")

    assert {:ok, %{}} =
             DosFlowtrackdApi.update_tcp_flow_filter(client, "acct", "flow_filter", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_tcp_flow_filter(client, "acct", "flow_filter")

    assert {:ok, []} = DosFlowtrackdApi.list_tcp_flow_rules(client, "acct")

    assert {:ok, %{"id" => "flow_rule"}} =
             DosFlowtrackdApi.create_tcp_flow_rule(client, "acct", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_tcp_flow_rules(client, "acct")

    assert {:ok, %{"id" => "flow_rule"}} =
             DosFlowtrackdApi.get_tcp_flow_rule(client, "acct", "flow_rule")

    assert {:ok, %{}} =
             DosFlowtrackdApi.update_tcp_flow_rule(client, "acct", "flow_rule", %{})

    assert {:ok, %{}} = DosFlowtrackdApi.delete_tcp_flow_rule(client, "acct", "flow_rule")

    assert {:ok, %{"enabled" => true}} = DosFlowtrackdApi.get_protection_status(client, "acct")

    assert {:ok, %{"enabled" => false}} =
             DosFlowtrackdApi.update_protection_status(client, "acct", %{"enabled" => false})
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 999}]}}}
    end)

    assert {:error, [%{"code" => 999}]} =
             DosFlowtrackdApi.list_dns_protection_rules(client, "acct")
  end

  defp rel(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
