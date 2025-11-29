defmodule CloudflareApi.AccountRulesetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountRulesets

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/rulesets?per_page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "r"}]}}}
    end)

    assert {:ok, [_]} = AccountRulesets.list(client, "acc", per_page: 2)
  end

  test "create_rule/4 posts JSON", %{client: client} do
    params = %{"action" => "allow"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/rulesets/ruleset/rules"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"action" => "allow"}}}}
    end)

    assert {:ok, %{"action" => "allow"}} =
             AccountRulesets.create_rule(client, "acc", "ruleset", params)
  end

  test "entrypoint/3 hits entrypoint endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/rulesets/phases/http_request_firewall_custom/entrypoint"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "entry"}}}}
    end)

    assert {:ok, %{"id" => "entry"}} =
             AccountRulesets.entrypoint(client, "acc", "http_request_firewall_custom")
  end
end
