defmodule CloudflareApi.CatalogSyncTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CatalogSync

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches syncs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/catalog-syncs"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "sync"}]}
       }}
    end)

    assert {:ok, [%{"id" => "sync"}]} = CatalogSync.list(client, "acc")
  end

  test "create/4 sends JSON body and headers", %{client: client} do
    params = %{"name" => "sync"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body, headers: headers} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/catalog-syncs"

      assert Jason.decode!(body) == params
      assert {"forwarded", "value"} in headers

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CatalogSync.create(client, "acc", params, [{"forwarded", "value"}])
  end

  test "prebuilt_policies/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/catalog-syncs/prebuilt-policies?destination_type=magic_firewall"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "policy"}]}
       }}
    end)

    assert {:ok, [%{"id" => "policy"}]} =
             CatalogSync.prebuilt_policies(client, "acc", destination_type: "magic_firewall")
  end

  test "refresh/3 posts to refresh endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/catalog-syncs/sync/refresh"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"state" => "queued"}}
       }}
    end)

    assert {:ok, %{"state" => "queued"}} = CatalogSync.refresh(client, "acc", "sync")
  end

  test "delete/4 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/catalog-syncs/sync?delete_destination=true"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "not found"}]} =
             CatalogSync.delete(client, "acc", "sync", delete_destination: true)
  end
end
