defmodule CloudflareApi.SecondaryDnsPrimaryZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecondaryDnsPrimaryZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches configuration", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/secondary_dns/outgoing"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = SecondaryDnsPrimaryZone.get(client, "zone")
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"peers" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsPrimaryZone.create(client, "zone", params)
  end

  test "enable_transfers/2 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/secondary_dns/outgoing/enable"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "enabled"}}}}
    end)

    assert {:ok, %{"status" => "enabled"}} =
             SecondaryDnsPrimaryZone.enable_transfers(client, "zone")
  end

  test "status/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} = SecondaryDnsPrimaryZone.status(client, "zone")
  end
end
