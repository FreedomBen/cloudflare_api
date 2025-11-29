defmodule CloudflareApi.SecondaryDnsSecondaryZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecondaryDnsSecondaryZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 hits incoming configuration endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/secondary_dns/incoming"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "zone"}}}}
    end)

    assert {:ok, %{"id" => "zone"}} = SecondaryDnsSecondaryZone.get(client, "zone")
  end

  test "create/3 posts JSON payload", %{client: client} do
    params = %{"primaries" => [%{"name_server" => "ns.example.com"}]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsSecondaryZone.create(client, "zone", params)
  end

  test "force_axfr/2 posts empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/secondary_dns/force_axfr"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "queued"}}}}
    end)

    assert {:ok, %{"status" => "queued"}} = SecondaryDnsSecondaryZone.force_axfr(client, "zone")
  end

  test "delete/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [%{"code" => 10}]} = SecondaryDnsSecondaryZone.delete(client, "zone")
  end
end
