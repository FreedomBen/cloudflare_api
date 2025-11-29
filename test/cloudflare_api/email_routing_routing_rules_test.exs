defmodule CloudflareApi.EmailRoutingRoutingRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EmailRoutingRoutingRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches routing rules", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/email/routing/rules"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rule"}]}}}
    end)

    assert {:ok, [_]} = EmailRoutingRoutingRules.list(client, "zone")
  end

  test "create/3 posts rule body", %{client: client} do
    params = %{"actions" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} =
             EmailRoutingRoutingRules.create(client, "zone", params)
  end

  test "get/3 retrieves rule", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/email/routing/rules/rule"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} =
             EmailRoutingRoutingRules.get(client, "zone", "rule")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"message" => "not found"}]}}}
    end)

    assert {:error, [%{"message" => "not found"}]} =
             EmailRoutingRoutingRules.update(client, "zone", "missing", %{})
  end

  test "catch-all helpers hit /catch_all", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/email/routing/rules/catch_all"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"actions" => []}}}}
    end)

    assert {:ok, %{"actions" => []}} =
             EmailRoutingRoutingRules.get_catch_all(client, "zone")
  end

  test "delete/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             EmailRoutingRoutingRules.delete(client, "zone", "rule")
  end
end
