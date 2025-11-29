defmodule CloudflareApi.KeylessSslZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.KeylessSslZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches keyless configs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/keyless_certificates"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = KeylessSslZone.list(client, "zone")
  end

  test "create/3 posts configuration", %{client: client} do
    params = %{"host" => "keyless.example.com", "port" => 24008, "certificate" => "PEM"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = KeylessSslZone.create(client, "zone", params)
  end

  test "update/4 patches config", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/keyless_certificates/keyless"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = KeylessSslZone.update(client, "zone", "keyless", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "keyless"}}}}
    end)

    assert {:ok, %{"id" => "keyless"}} = KeylessSslZone.delete(client, "zone", "keyless")
  end
end
