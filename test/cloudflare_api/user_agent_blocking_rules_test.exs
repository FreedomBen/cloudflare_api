defmodule CloudflareApi.UserAgentBlockingRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UserAgentBlockingRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits ua rules endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/ua_rules?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"description" => "block bot"}]}}}
    end)

    assert {:ok, [%{"description" => "block bot"}]} =
             UserAgentBlockingRules.list(client, "zone", page: 1)
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"mode" => "block"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = UserAgentBlockingRules.create(client, "zone", params)
  end

  test "update/4 uses PUT", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             UserAgentBlockingRules.update(client, "zone", "rule", params)
  end

  test "delete/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1001}]}}}
    end)

    assert {:error, [%{"code" => 1001}]} =
             UserAgentBlockingRules.delete(client, "zone", "missing")
  end
end
