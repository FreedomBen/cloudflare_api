defmodule CloudflareApi.ZoneAccessPoliciesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessPolicies

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 hits the policies collection", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/access/apps/app/policies?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pol"}]}}}
    end)

    assert {:ok, [%{"id" => "pol"}]} =
             ZoneAccessPolicies.list(client, "zone", "app", page: 1)
  end

  test "create/get/update/delete operate on nested resource", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/policies"
        assert Jason.decode!(body) == %{"decision" => "allow"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"decision" => "allow"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/policies/pol"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pol"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/policies/pol"
        assert Jason.decode!(body) == %{"decision" => "deny"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"decision" => "deny"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/policies/pol"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"decision" => "allow"}} =
             ZoneAccessPolicies.create(client, "zone", "app", %{"decision" => "allow"})

    assert {:ok, %{"id" => "pol"}} = ZoneAccessPolicies.get(client, "zone", "app", "pol")

    assert {:ok, %{"decision" => "deny"}} =
             ZoneAccessPolicies.update(client, "zone", "app", "pol", %{"decision" => "deny"})

    assert {:ok, %{}} = ZoneAccessPolicies.delete(client, "zone", "app", "pol")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 900}]}}}
    end)

    assert {:error, [%{"code" => 900}]} =
             ZoneAccessPolicies.list(client, "zone", "missing_app")
  end
end
