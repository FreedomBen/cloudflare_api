defmodule CloudflareApi.DlpEmailTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpEmail

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_account_mapping/2 hits mapping endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/email/account_mapping"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"mapping" => "data"}}}}
    end)

    assert {:ok, %{"mapping" => "data"}} = DlpEmail.get_account_mapping(client, "acc")
  end

  test "create_account_mapping/3 posts JSON", %{client: client} do
    params = %{"type" => "enterprise"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/email/account_mapping"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = DlpEmail.create_account_mapping(client, "acc", params)
  end

  test "list_rules/2 returns rules", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/email/rules"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rule"}]}}}
    end)

    assert {:ok, [_]} = DlpEmail.list_rules(client, "acc")
  end

  test "create_rule/3 posts new rule", %{client: client} do
    params = %{"name" => "Rule"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/email/rules"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} = DlpEmail.create_rule(client, "acc", params)
  end

  test "update_rule_priorities/3 patches priorities", %{client: client} do
    params = %{"priorities" => ["rule1", "rule2"]}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/email/rules"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             DlpEmail.update_rule_priorities(client, "acc", params)
  end

  test "get_rule/3 fetches a single rule", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/email/rules/rule"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} = DlpEmail.get_rule(client, "acc", "rule")
  end

  test "update_rule/4 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             DlpEmail.update_rule(client, "acc", "rule", %{"name" => "New"})
  end

  test "delete_rule/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} = DlpEmail.delete_rule(client, "acc", "rule")
  end
end
