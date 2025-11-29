defmodule CloudflareApi.PagesBuildCacheTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PagesBuildCache

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "purge/3 POSTs empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/pages/projects/project/purge_build_cache"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"purged" => true}}}}
    end)

    assert {:ok, %{"purged" => true}} = PagesBuildCache.purge(client, "acc", "project")
  end

  test "purge/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} = PagesBuildCache.purge(client, "acc", "project")
  end
end
