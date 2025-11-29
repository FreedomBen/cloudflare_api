defmodule CloudflareApi.PageShieldTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PageShield

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_settings/2 hits settings endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/page_shield"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = PageShield.get_settings(client, "zone")
  end

  test "update_settings/3 PUTs JSON body", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = PageShield.update_settings(client, "zone", params)
  end

  test "create_policy/3 posts policy payload", %{client: client} do
    params = %{"name" => "block"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/page_shield/policies"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = PageShield.create_policy(client, "zone", params)
  end

  test "delete_policy/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = PageShield.delete_policy(client, "zone", "pol")
  end

  test "list_scripts/3 supports query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/page_shield/scripts?page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "script"}]}}}
    end)

    assert {:ok, [%{"id" => "script"}]} = PageShield.list_scripts(client, "zone", page: 2)
  end

  test "get_connection/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 50}]}}}
    end)

    assert {:error, [%{"code" => 50}]} = PageShield.get_connection(client, "zone", "conn")
  end
end
