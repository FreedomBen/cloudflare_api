defmodule CloudflareApi.MagicSiteAclsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicSiteAcls

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 fetches ACLs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/sites/site/acls"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicSiteAcls.list(client, "acc", "site")
  end

  test "update/5 patches data", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/sites/site/acls/acl"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MagicSiteAcls.patch(client, "acc", "site", "acl", params)
  end
end
