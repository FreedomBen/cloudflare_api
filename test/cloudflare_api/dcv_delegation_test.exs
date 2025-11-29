defmodule CloudflareApi.DcvDelegationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DcvDelegation

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_uuid/2 hits the delegated UUID endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/dcv_delegation/uuid"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"uuid" => "abc"}}}}
    end)

    assert {:ok, %{"uuid" => "abc"}} = DcvDelegation.get_uuid(client, "zone")
  end

  test "get_uuid/2 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1200}]}}}
    end)

    assert {:error, [%{"code" => 1200}]} = DcvDelegation.get_uuid(client, "zone")
  end
end
