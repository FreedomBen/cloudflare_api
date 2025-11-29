defmodule CloudflareApi.PhysicalDevicesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PhysicalDevices

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 applies pagination", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices/physical-devices?page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "dev"}]}}}
    end)

    assert {:ok, [%{"id" => "dev"}]} = PhysicalDevices.list(client, "acc", page: 2)
  end

  test "revoke/4 posts JSON body", %{client: client} do
    params = %{"reason" => "lost"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices/physical-devices/dev/revoke"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"revoked" => true}}}}
    end)

    assert {:ok, %{"revoked" => true}} = PhysicalDevices.revoke(client, "acc", "dev", params)
  end

  test "delete_registrations/3 sends provided JSON", %{client: client} do
    params = %{"device_ids" => ["dev"]}

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices/registrations"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => 1}}}}
    end)

    assert {:ok, %{"deleted" => 1}} = PhysicalDevices.delete_registrations(client, "acc", params)
  end

  test "get/3 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} = PhysicalDevices.get(client, "acc", "missing")
  end
end
