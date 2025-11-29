defmodule CloudflareApi.ArgoSmartRoutingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ArgoSmartRouting

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches smart routing state", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/argo/smart_routing"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"value" => "on"}}
       }}
    end)

    assert {:ok, %{"value" => "on"}} = ArgoSmartRouting.get(client, "zone")
  end

  test "patch/3 passes params and reports errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/argo/smart_routing"
      assert Jason.decode!(body) == %{"value" => "off"}

      {:ok,
       %Tesla.Env{
         env
         | status: 422,
           body: %{"errors" => [%{"code" => 2001, "message" => "cannot disable"}]}
       }}
    end)

    assert {:error, [%{"code" => 2001, "message" => "cannot disable"}]} =
             ArgoSmartRouting.patch(client, "zone", %{"value" => "off"})
  end
end
