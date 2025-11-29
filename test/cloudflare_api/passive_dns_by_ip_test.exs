defmodule CloudflareApi.PassiveDnsByIpTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PassiveDnsByIp

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 applies query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/intel/dns?ip=1.2.3.4"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"hostname" => "example.com"}]}}}
    end)

    assert {:ok, [%{"hostname" => "example.com"}]} =
             PassiveDnsByIp.get(client, "acc", ip: "1.2.3.4")
  end

  test "get/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1001}]}}}
    end)

    assert {:error, [%{"code" => 1001}]} = PassiveDnsByIp.get(client, "acc")
  end
end
