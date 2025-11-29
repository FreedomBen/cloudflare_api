defmodule CloudflareApi.DeviceManagedNetworksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DeviceManagedNetworks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches networks", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/networks"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "net"}]}}}
    end)

    assert {:ok, [_]} = DeviceManagedNetworks.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "net"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "net"}}}}
    end)

    assert {:ok, %{"id" => "net"}} =
             DeviceManagedNetworks.create(client, "acc", params)
  end

  test "get/3 returns network details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/networks/net"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "net"}}}}
    end)

    assert {:ok, %{"id" => "net"}} =
             DeviceManagedNetworks.get(client, "acc", "net")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"message" => "not found"}]}}}
    end)

    assert {:error, [%{"message" => "not found"}]} =
             DeviceManagedNetworks.update(client, "acc", "missing", %{"name" => "new"})
  end

  test "delete/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DeviceManagedNetworks.delete(client, "acc", "net")
  end
end
