defmodule CloudflareApi.DnsFirewallTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DnsFirewall

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches clusters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_firewall"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cluster"}]}}}
    end)

    assert {:ok, [_]} = DnsFirewall.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "cluster"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cluster"}}}}
    end)

    assert {:ok, %{"id" => "cluster"}} = DnsFirewall.create(client, "acc", params)
  end

  test "get/3 retrieves a cluster", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_firewall/cluster"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cluster"}}}}
    end)

    assert {:ok, %{"id" => "cluster"}} = DnsFirewall.get(client, "acc", "cluster")
  end

  test "update/4 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 1001}]}}}
    end)

    assert {:error, [%{"code" => 1001}]} =
             DnsFirewall.update(client, "acc", "cluster", %{"name" => "new"})
  end

  test "delete/3 sends empty object body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = DnsFirewall.delete(client, "acc", "cluster")
  end

  test "reverse_dns/3 fetches reverse DNS settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dns_firewall/cluster/reverse_dns"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"hostname" => "example"}}}}
    end)

    assert {:ok, %{"hostname" => "example"}} =
             DnsFirewall.reverse_dns(client, "acc", "cluster")
  end

  test "update_reverse_dns/4 posts JSON body", %{client: client} do
    params = %{"hostname" => "example.cloudflare-dns.com"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             DnsFirewall.update_reverse_dns(client, "acc", "cluster", params)
  end
end
