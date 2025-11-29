defmodule CloudflareApi.DevicePostureRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DevicePostureRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches posture rules", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/posture"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rule"}]}}}
    end)

    assert {:ok, [_]} = DevicePostureRules.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "rule"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} =
             DevicePostureRules.create(client, "acc", params)
  end

  test "get/3 retrieves rule details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/posture/rule"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} =
             DevicePostureRules.get(client, "acc", "rule")
  end

  test "update/4 uses PUT and handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"message" => "conflict"}]}}}
    end)

    assert {:error, [%{"message" => "conflict"}]} =
             DevicePostureRules.update(client, "acc", "rule", %{"name" => "new"})
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DevicePostureRules.delete(client, "acc", "rule")
  end
end
