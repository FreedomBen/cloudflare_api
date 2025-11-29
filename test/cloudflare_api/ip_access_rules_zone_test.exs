defmodule CloudflareApi.IpAccessRulesZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAccessRulesZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 includes zone_id segment", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/access_rules/rules?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAccessRulesZone.list(client, "zone", page: 1)
  end

  test "create/3 posts payload", %{client: client} do
    params = %{
      "mode" => "challenge",
      "configuration" => %{"target" => "ip", "value" => "1.1.1.1"}
    }

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAccessRulesZone.create(client, "zone", params)
  end

  test "delete/4 supports cascade option", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{"cascade" => "basic"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "r1"}}}}
    end)

    assert {:ok, %{"id" => "r1"}} =
             IpAccessRulesZone.delete(client, "zone", "r1", cascade: "basic")
  end

  test "update/4 patches rule metadata", %{client: client} do
    params = %{"notes" => "updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/firewall/access_rules/rules/r1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAccessRulesZone.update(client, "zone", "r1", params)
  end

  test "handle_response/1 returns API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpAccessRulesZone.list(client, "zone")
  end
end
