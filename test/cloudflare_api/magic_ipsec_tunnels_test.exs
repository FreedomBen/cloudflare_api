defmodule CloudflareApi.MagicIpsecTunnelsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicIpsecTunnels

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches IPsec tunnels", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/ipsec_tunnels"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicIpsecTunnels.list(client, "acc")
  end

  test "create/3 posts tunnel definition", %{client: client} do
    params = %{"name" => "ipsec-1"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicIpsecTunnels.create(client, "acc", params)
  end

  test "generate_psk/3 posts empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"psk" => "secret"}}}}
    end)

    assert {:ok, %{"psk" => "secret"}} = MagicIpsecTunnels.generate_psk(client, "acc", "tunnel")
  end

  test "update_many/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 9100}]}}}
    end)

    assert {:error, [%{"code" => 9100}]} =
             MagicIpsecTunnels.update_many(client, "acc", %{"items" => []})
  end
end
