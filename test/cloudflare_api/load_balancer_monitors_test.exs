defmodule CloudflareApi.LoadBalancerMonitorsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LoadBalancerMonitors

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/1 fetches monitors", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/user/load_balancers/monitors"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = LoadBalancerMonitors.list(client)
  end

  test "create/2 posts monitor payload", %{client: client} do
    params = %{"type" => "https", "path" => "/", "interval" => 60}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancerMonitors.create(client, params)
  end

  test "get/2 fetches monitor by id", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/monitors/mon"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "mon"}}}}
    end)

    assert {:ok, %{"id" => "mon"}} = LoadBalancerMonitors.get(client, "mon")
  end

  test "update/3 uses PUT", %{client: client} do
    params = %{"interval" => 120}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/monitors/mon"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancerMonitors.update(client, "mon", params)
  end

  test "patch/3 uses PATCH", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/monitors/mon"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LoadBalancerMonitors.patch(client, "mon", params)
  end

  test "delete/2 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "mon"}}}}
    end)

    assert {:ok, %{"id" => "mon"}} = LoadBalancerMonitors.delete(client, "mon")
  end

  test "preview/3 posts monitor data", %{client: client} do
    params = %{"type" => "https"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/monitors/mon/preview"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"preview_id" => "prev"}}}}
    end)

    assert {:ok, %{"preview_id" => "prev"}} =
             LoadBalancerMonitors.preview(client, "mon", params)
  end

  test "references/2 fetches referencing resources", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/monitors/mon/references"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"type" => "pool"}]}}}
    end)

    assert {:ok, [%{"type" => "pool"}]} = LoadBalancerMonitors.references(client, "mon")
  end

  test "preview_result/2 retrieves preview details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/load_balancers/preview/prev"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} = LoadBalancerMonitors.preview_result(client, "prev")
  end

  test "update/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 100}]}}}
    end)

    assert {:error, [%{"code" => 100}]} =
             LoadBalancerMonitors.update(client, "mon", %{"interval" => 60})
  end
end
