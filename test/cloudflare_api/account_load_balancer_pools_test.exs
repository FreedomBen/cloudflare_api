defmodule CloudflareApi.AccountLoadBalancerPoolsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountLoadBalancerPools

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/pools?per_page=3"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pool"}]}}}
    end)

    assert {:ok, [_]} = AccountLoadBalancerPools.list(client, "acc", per_page: 3)
  end

  test "patch_many/3 sends JSON", %{client: client} do
    params = %{"pools" => []}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/pools"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccountLoadBalancerPools.patch_many(client, "acc", params)
  end

  test "health/3 hits health endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/pools/pool/health"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"healthy" => true}}}}
    end)

    assert {:ok, %{"healthy" => true}} =
             AccountLoadBalancerPools.health(client, "acc", "pool")
  end
end
