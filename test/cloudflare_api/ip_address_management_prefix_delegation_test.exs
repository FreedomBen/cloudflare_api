defmodule CloudflareApi.IpAddressManagementPrefixDelegationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementPrefixDelegation

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits delegations path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/pfx/delegations"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAddressManagementPrefixDelegation.list(client, "acc", "pfx")
  end

  test "create/4 posts delegation payload", %{client: client} do
    params = %{"cidr" => "198.51.100.0/24", "delegated_account_id" => "subacc"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             IpAddressManagementPrefixDelegation.create(client, "acc", "pfx", params)
  end

  test "delete/4 sends empty payload", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "delegation"}}}}
    end)

    assert {:ok, %{"id" => "delegation"}} =
             IpAddressManagementPrefixDelegation.delete(client, "acc", "pfx", "delegation")
  end
end
