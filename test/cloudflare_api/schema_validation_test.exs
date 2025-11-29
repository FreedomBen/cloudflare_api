defmodule CloudflareApi.SchemaValidationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SchemaValidation

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_schemas/3 requests schema list", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/schema_validation/schemas"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "schema"}]}}}
    end)

    assert {:ok, [%{"id" => "schema"}]} = SchemaValidation.list_schemas(client, "zone")
  end

  test "create_schema/3 posts JSON body", %{client: client} do
    params = %{"name" => "schema"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SchemaValidation.create_schema(client, "zone", params)
  end

  test "extract_operations/4 encodes schema id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/schema_validation/schemas/schema/operations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = SchemaValidation.extract_operations(client, "zone", "schema")
  end

  test "delete_schema/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = SchemaValidation.delete_schema(client, "zone", "schema")
  end

  test "get_schema/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 19}]}}}
    end)

    assert {:error, [%{"code" => 19}]} = SchemaValidation.get_schema(client, "zone", "missing")
  end
end
