defmodule CloudflareApi.ZeroTrustGatewayRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustGatewayRules

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/rules?page=2&per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustGatewayRules.list(client, "acc", page: 2, per_page: 10)
  end

  test "list_tenant_rules/3 hits tenant path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/rules/tenant?cursor=abc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustGatewayRules.list_tenant_rules(client, "acc", cursor: "abc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "rule"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/rules"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayRules.create(client, "acc", params)
  end

  test "delete/3 issues DELETE body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/rules/rule%2F1"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustGatewayRules.delete(client, "acc", "rule/1")
  end

  test "get/3 fetches rule", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/rules/rule%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule/1"}}}}
    end)

    assert {:ok, %{"id" => "rule/1"}} =
             ZeroTrustGatewayRules.get(client, "acc", "rule/1")
  end

  test "update/4 puts JSON", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/gateway/rules/rule"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayRules.update(client, "acc", "rule", params)
  end

  test "reset_expiration/4 posts JSON", %{client: client} do
    params = %{"days" => 7}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/rules/rule/reset_expiration"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustGatewayRules.reset_expiration(client, "acc", "rule", params)
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 9}]}}}
    end)

    assert {:error, [_]} = ZeroTrustGatewayRules.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
