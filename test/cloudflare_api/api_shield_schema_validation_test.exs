defmodule CloudflareApi.ApiShieldSchemaValidationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ApiShieldSchemaValidation

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_zone_settings/2 hits correct URL", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url:
                "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/settings/schema_validation"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             ApiShieldSchemaValidation.get_zone_settings(client, "zone")
  end

  test "patch_zone_settings/3 sends JSON body", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ApiShieldSchemaValidation.patch_zone_settings(client, "zone", params)
  end

  test "update_operation_settings/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/operations/op/schema_validation"

      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 88}]}}}
    end)

    assert {:error, [%{"code" => 88}]} =
             ApiShieldSchemaValidation.update_operation_settings(client, "zone", "op", %{})
  end

  test "list_user_schemas/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/user_schemas?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "schema"}]}}}
    end)

    assert {:ok, [%{"id" => "schema"}]} =
             ApiShieldSchemaValidation.list_user_schemas(client, "zone", page: 2)
  end

  test "create_user_schema/3 sends payload", %{client: client} do
    params = %{"host" => "api.example.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ApiShieldSchemaValidation.create_user_schema(client, "zone", params)
  end

  test "extract_operations/3 returns result", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url:
                "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/user_schemas/id/operations"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"path" => "/"}]}}}
    end)

    assert {:ok, [_]} = ApiShieldSchemaValidation.extract_operations(client, "zone", "id")
  end
end
