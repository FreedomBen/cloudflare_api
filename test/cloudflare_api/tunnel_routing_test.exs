defmodule CloudflareApi.TunnelRoutingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TunnelRouting

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/teamnet/routes?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"comment" => "route"}]}}}
    end)

    assert {:ok, [%{"comment" => "route"}]} =
             TunnelRouting.list(client, "acc", page: 2)
  end

  test "create_with_cidr/4 hits network endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/teamnet/routes/network/10.0.0.0%2F24"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"network" => "10.0.0.0/24"}}}}
    end)

    assert {:ok, %{"network" => "10.0.0.0/24"}} =
             TunnelRouting.create_with_cidr(client, "acc", "10.0.0.0/24", %{})
  end

  test "get_by_ip/3 fetches route for IP", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/teamnet/routes/ip/203.0.113.5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ip" => "203.0.113.5"}}}}
    end)

    assert {:ok, %{"ip" => "203.0.113.5"}} =
             TunnelRouting.get_by_ip(client, "acc", "203.0.113.5")
  end

  test "delete_with_cidr/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} =
             TunnelRouting.delete_with_cidr(client, "acc", "10.0.0.0/24")
  end
end
