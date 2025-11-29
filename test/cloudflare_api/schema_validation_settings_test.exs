defmodule CloudflareApi.SchemaValidationSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SchemaValidationSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_settings/3 hits settings endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/schema_validation/settings"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = SchemaValidationSettings.get_settings(client, "zone")
  end

  test "patch_settings/3 PATCHes payload", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/schema_validation/settings"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SchemaValidationSettings.patch_settings(client, "zone", params)
  end

  test "update_operation_setting/5 uses PUT", %{client: client} do
    params = %{"action" => "log"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/schema_validation/settings/operations/op"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SchemaValidationSettings.update_operation_setting(client, "zone", "op", params)
  end

  test "delete_operation_setting/4 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             SchemaValidationSettings.delete_operation_setting(client, "zone", "op")
  end

  test "list_operations/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 15}]}}}
    end)

    assert {:error, [%{"code" => 15}]} = SchemaValidationSettings.list_operations(client, "zone")
  end
end
