defmodule CloudflareApi.DevicesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Devices

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits deprecated devices endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "dev"}]}}}
    end)

    assert {:ok, [_]} = Devices.list(client, "acc")
  end

  test "create_policy/3 posts JSON", %{client: client} do
    params = %{"name" => "policy"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices/policy"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "policy"}}}}
    end)

    assert {:ok, %{"id" => "policy"}} = Devices.create_policy(client, "acc", params)
  end

  test "split tunnel include/exclude helpers call proper endpoints", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: "https://api.cloudflare.com/client/v4/accounts/acc/devices/policy/include"} = env ->
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

      %Tesla.Env{method: :put, url: "https://api.cloudflare.com/client/v4/accounts/acc/devices/policy/include"} = env ->
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, []} = Devices.split_tunnel_include(client, "acc")
    assert {:ok, %{"ok" => true}} = Devices.set_split_tunnel_include(client, "acc", %{"value" => []})
  end

  test "policy-specific split tunnel endpoints use policy id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/policy/pol/fallback_domains"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"domains" => []}}}}
    end)

    assert {:ok, %{"domains" => []}} =
             Devices.policy_fallback_domains(client, "acc", "pol")
  end

  test "update_policy/4 propagates Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             Devices.update_policy(client, "acc", "pol", %{"name" => "new"})
  end

  test "revoke/unrevoke/3 post payloads", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/revoke"

      assert Jason.decode!(body) == %{"devices" => ["1"]}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"revoked" => true}}}}
    end)

    assert {:ok, %{"revoked" => true}} =
             Devices.revoke(client, "acc", %{"devices" => ["1"]})
  end

  test "override codes/2 fetch override list", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/device/override_codes"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Devices.override_codes(client, "acc", "device")
  end

  test "certificate_status/2 uses zone endpoint", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: "https://api.cloudflare.com/client/v4/zones/zone/devices/policy/certificates"} = env ->
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "enabled"}}}}
    end)

    assert {:ok, %{"status" => "enabled"}} = Devices.certificate_status(client, "zone")
  end
end
