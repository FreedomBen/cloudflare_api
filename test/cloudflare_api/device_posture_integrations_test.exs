defmodule CloudflareApi.DevicePostureIntegrationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DevicePostureIntegrations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches integrations", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/posture/integration"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "int"}]}}}
    end)

    assert {:ok, [_]} = DevicePostureIntegrations.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "int"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "int"}}}}
    end)

    assert {:ok, %{"id" => "int"}} =
             DevicePostureIntegrations.create(client, "acc", params)
  end

  test "get/3 retrieves integration", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/posture/integration/int"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "int"}}}}
    end)

    assert {:ok, %{"id" => "int"}} =
             DevicePostureIntegrations.get(client, "acc", "int")
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [%{"code" => 10}]} =
             DevicePostureIntegrations.update(client, "acc", "int", %{"name" => "new"})
  end

  test "delete/3 sends empty object body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DevicePostureIntegrations.delete(client, "acc", "int")
  end
end
