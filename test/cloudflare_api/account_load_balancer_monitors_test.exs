defmodule CloudflareApi.AccountLoadBalancerMonitorsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountLoadBalancerMonitors

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/monitors?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "mon"}]}}}
    end)

    assert {:ok, [_]} = AccountLoadBalancerMonitors.list(client, "acc", per_page: 5)
  end

  test "preview/4 posts params", %{client: client} do
    params = %{"description" => "test"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/monitors/mon/preview"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"preview_id" => "abc"}}}}
    end)

    assert {:ok, %{"preview_id" => "abc"}} =
             AccountLoadBalancerMonitors.preview(client, "acc", "mon", params)
  end

  test "preview_result/3 hits preview endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/preview/prev"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} =
             AccountLoadBalancerMonitors.preview_result(client, "acc", "prev")
  end
end
