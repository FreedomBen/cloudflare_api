defmodule CloudflareApi.TunnelVirtualNetworkTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TunnelVirtualNetwork

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits base path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/teamnet/virtual_networks?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "vnet"}]}}}
    end)

    assert {:ok, [%{"name" => "vnet"}]} =
             TunnelVirtualNetwork.list(client, "acc", page: 1)
  end

  test "update/4 patches payload", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             TunnelVirtualNetwork.update(client, "acc", "id", params)
  end

  test "delete/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 60}]}}}
    end)

    assert {:error, [%{"code" => 60}]} =
             TunnelVirtualNetwork.delete(client, "acc", "id")
  end
end
