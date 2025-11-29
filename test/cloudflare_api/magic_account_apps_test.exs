defmodule CloudflareApi.MagicAccountAppsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicAccountApps

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches account apps", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/apps"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicAccountApps.list(client, "acc")
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"name" => "magic-app"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 201, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicAccountApps.create(client, "acc", params)
  end

  test "update/4 uses PUT", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/apps/app1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicAccountApps.update(client, "acc", "app1", params)
  end

  test "delete/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1001}]}}}
    end)

    assert {:error, [%{"code" => 1001}]} = MagicAccountApps.delete(client, "acc", "missing")
  end
end
