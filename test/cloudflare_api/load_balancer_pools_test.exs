defmodule CloudflareApi.LoadBalancerPoolsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LoadBalancerPools

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 allows monitor filter", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/pools?monitor=mon"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = LoadBalancerPools.list(client, monitor: "mon")
  end

  test "create/2 posts pool definition", %{client: client} do
    params = %{"name" => "primary", "origins" => [%{"name" => "a"}]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancerPools.create(client, params)
  end

  test "get/2 fetches pool", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/pools/pool1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pool1"}}}}
    end)

    assert {:ok, %{"id" => "pool1"}} = LoadBalancerPools.get(client, "pool1")
  end

  test "update/3 uses PUT", %{client: client} do
    params = %{"name" => "primary", "origins" => [%{"name" => "a"}]}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancerPools.update(client, "pool1", params)
  end

  test "patch/3 uses PATCH", %{client: client} do
    params = %{"description" => "new"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/pools/pool1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancerPools.patch(client, "pool1", params)
  end

  test "delete/2 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pool1"}}}}
    end)

    assert {:ok, %{"id" => "pool1"}} = LoadBalancerPools.delete(client, "pool1")
  end

  test "health/2 retrieves health info", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/pools/pool1/health"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"healthy" => true}}}}
    end)

    assert {:ok, %{"healthy" => true}} = LoadBalancerPools.health(client, "pool1")
  end

  test "preview/3 posts monitor details", %{client: client} do
    params = %{"type" => "https"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/pools/pool1/preview"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"preview_id" => "prev"}}}}
    end)

    assert {:ok, %{"preview_id" => "prev"}} =
             LoadBalancerPools.preview(client, "pool1", params)
  end

  test "references/2 fetches referencing resources", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/pools/pool1/references"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"type" => "lb"}]}}}
    end)

    assert {:ok, [%{"type" => "lb"}]} = LoadBalancerPools.references(client, "pool1")
  end

  test "patch_bulk/2 updates multiple pools", %{client: client} do
    params = %{"notification_email" => "ops@example.com"}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/user/load_balancers/pools"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = LoadBalancerPools.patch_bulk(client, params)
  end

  test "update/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 9103}]}}}
    end)

    assert {:error, [%{"code" => 9103}]} =
             LoadBalancerPools.update(client, "pool1", %{"name" => "primary", "origins" => []})
  end
end
