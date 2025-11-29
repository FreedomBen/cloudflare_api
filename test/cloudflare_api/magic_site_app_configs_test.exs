defmodule CloudflareApi.MagicSiteAppConfigsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicSiteAppConfigs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/4 posts params", %{client: client} do
    params = %{"name" => "config"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/sites/site/app_configs"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MagicSiteAppConfigs.create(client, "acc", "site", params)
  end

  test "delete/4 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 8000}]}}}
    end)

    assert {:error, [%{"code" => 8000}]} =
             MagicSiteAppConfigs.delete(client, "acc", "site", "cfg")
  end
end
