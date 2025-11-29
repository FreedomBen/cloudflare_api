defmodule CloudflareApi.MagicSiteWansTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicSiteWans

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 fetches wans", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/sites/site/wans"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicSiteWans.list(client, "acc", "site")
  end

  test "delete/4 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 321}]}}}
    end)

    assert {:error, [%{"code" => 321}]} = MagicSiteWans.delete(client, "acc", "site", "wan")
  end
end
