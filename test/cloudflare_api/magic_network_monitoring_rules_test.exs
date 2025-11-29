defmodule CloudflareApi.MagicNetworkMonitoringRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicNetworkMonitoringRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches rules", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/mnm/rules"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicNetworkMonitoringRules.list(client, "acc")
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"rules" => [%{"name" => "rule"}]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicNetworkMonitoringRules.create(client, "acc", params)
  end

  test "update_advertisement/4 hits advertisement endpoint", %{client: client} do
    params = %{"advertisement" => %{"state" => "enabled"}}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/mnm/rules/rule1/advertisement"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MagicNetworkMonitoringRules.update_advertisement(client, "acc", "rule1", params)
  end

  test "delete/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             MagicNetworkMonitoringRules.delete(client, "acc", "missing")
  end
end
