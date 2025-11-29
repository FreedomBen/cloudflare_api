defmodule CloudflareApi.MagicGreTunnelsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicGreTunnels

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches GRE tunnels", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/gre_tunnels"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicGreTunnels.list(client, "acc")
  end

  test "create/3 posts tunnel definition", %{client: client} do
    params = %{"name" => "gre-1"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicGreTunnels.create(client, "acc", params)
  end

  test "update_many/3 uses base PUT", %{client: client} do
    params = %{"items" => []}

    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/gre_tunnels"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicGreTunnels.update_many(client, "acc", params)
  end

  test "delete/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 7002}]}}}
    end)

    assert {:error, [%{"code" => 7002}]} = MagicGreTunnels.delete(client, "acc", "missing")
  end
end
