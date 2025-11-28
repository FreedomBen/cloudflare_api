defmodule CloudflareApi.ApiShieldEndpointManagementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ApiShieldEndpointManagement

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_operations/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/operations?page=3"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "op"}]}}}
    end)

    assert {:ok, [%{"id" => "op"}]} =
             ApiShieldEndpointManagement.list_operations(client, "zone", page: 3)
  end

  test "create_operation/3 sends JSON body", %{client: client} do
    params = %{"method" => "GET"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/operations/item"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ApiShieldEndpointManagement.create_operation(client, "zone", params)
  end

  test "delete_operations/3 sends payload", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{"ids" => ["one"]}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => 1}}}}
    end)

    assert {:ok, %{"deleted" => 1}} =
             ApiShieldEndpointManagement.delete_operations(client, "zone", %{"ids" => ["one"]})
  end

  test "fetch_schemas/2 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} = ApiShieldEndpointManagement.fetch_schemas(client, "zone")
  end
end
