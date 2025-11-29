defmodule CloudflareApi.TenantsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Tenants

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches tenant data", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/tenants/tenant?expand=true"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "Tenant"}}}}
    end)

    assert {:ok, %{"name" => "Tenant"}} = Tenants.get(client, "tenant", expand: true)
  end

  test "accounts/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/tenants/tenant/accounts?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "acct"}]}}}
    end)

    assert {:ok, [%{"id" => "acct"}]} = Tenants.accounts(client, "tenant", page: 2)
  end

  test "entitlements/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9001}]}}}
    end)

    assert {:error, [%{"code" => 9001}]} =
             Tenants.entitlements(client, "tenant")
  end
end
