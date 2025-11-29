defmodule CloudflareApi.IpAddressManagementAddressMapsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementAddressMaps

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches maps", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/address_maps"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAddressManagementAddressMaps.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"description" => "map"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAddressManagementAddressMaps.create(client, "acc", params)
  end

  test "update/4 patches map", %{client: client} do
    params = %{"enabled" => true}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/address_maps/map"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAddressManagementAddressMaps.update(client, "acc", "map", params)
  end

  test "membership helpers send empty JSON bodies", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      assert Jason.decode!(env.body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             IpAddressManagementAddressMaps.add_account_membership(
               client,
               "acc",
               "map",
               "member"
             )
  end

  test "remove_ip/4 hits IP path", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/address_maps/map/ips/192.0.2.1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "map"}}}}
    end)

    assert {:ok, %{"id" => "map"}} =
             IpAddressManagementAddressMaps.remove_ip(client, "acc", "map", "192.0.2.1")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpAddressManagementAddressMaps.list(client, "acc")
  end
end
