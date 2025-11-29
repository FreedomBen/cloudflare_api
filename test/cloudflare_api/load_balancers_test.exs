defmodule CloudflareApi.LoadBalancersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LoadBalancers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches load balancers", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/load_balancers"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = LoadBalancers.list(client, "zone")
  end

  test "create/3 posts load balancer definition", %{client: client} do
    params = %{
      "name" => "lb.example.com",
      "default_pools" => ["pool1"],
      "fallback_pool" => "pool2"
    }

    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/load_balancers"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancers.create(client, "zone", params)
  end

  test "get/3 fetches load balancer", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/load_balancers/lb1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "lb1"}}}}
    end)

    assert {:ok, %{"id" => "lb1"}} = LoadBalancers.get(client, "zone", "lb1")
  end

  test "update/4 uses PUT", %{client: client} do
    params = %{
      "name" => "lb.example.com",
      "default_pools" => ["pool1"],
      "fallback_pool" => "pool2"
    }

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancers.update(client, "zone", "lb1", params)
  end

  test "patch/4 uses PATCH", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/load_balancers/lb1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancers.patch(client, "zone", "lb1", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "lb1"}}}}
    end)

    assert {:ok, %{"id" => "lb1"}} = LoadBalancers.delete(client, "zone", "lb1")
  end

  test "create/3 propagates Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 2032}]}}}
    end)

    assert {:error, [%{"code" => 2032}]} =
             LoadBalancers.create(client, "zone", %{
               "name" => "lb.example.com",
               "default_pools" => [],
               "fallback_pool" => "pool"
             })
  end
end
