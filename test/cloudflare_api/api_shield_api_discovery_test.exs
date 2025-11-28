defmodule CloudflareApi.ApiShieldApiDiscoveryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ApiShieldApiDiscovery

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "fetch_openapi/2 hits discovery endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/discovery"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"openapi" => "3.0"}}}}
    end)

    assert {:ok, %{"openapi" => "3.0"}} = ApiShieldApiDiscovery.fetch_openapi(client, "zone")
  end

  test "list_operations/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/discovery/operations?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "op"}]}}}
    end)

    assert {:ok, [%{"id" => "op"}]} =
             ApiShieldApiDiscovery.list_operations(client, "zone", page: 2)
  end

  test "patch_operations/3 sends JSON body", %{client: client} do
    params = %{"operations" => [%{"id" => "op"}]}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/discovery/operations"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"updated" => 1}}}}
    end)

    assert {:ok, %{"updated" => 1}} =
             ApiShieldApiDiscovery.patch_operations(client, "zone", params)
  end

  test "update_operation/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/discovery/operations/op"

      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} =
             ApiShieldApiDiscovery.update_operation(client, "zone", "op", %{})
  end
end
