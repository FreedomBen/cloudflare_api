defmodule CloudflareApi.CacheReserveClearTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CacheReserveClear

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches cache reserve clear status", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/smart_shield/cache_reserve_clear"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"state" => "Completed"}}
       }}
    end)

    assert {:ok, %{"state" => "Completed"}} = CacheReserveClear.get(client, "zone")
  end

  test "start/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/smart_shield/cache_reserve_clear"

      {:ok,
       %Tesla.Env{
         env
         | status: 409,
           body: %{"errors" => [%{"code" => 1153, "message" => "in progress"}]}
       }}
    end)

    assert {:error, [%{"code" => 1153, "message" => "in progress"}]} =
             CacheReserveClear.start(client, "zone")
  end
end
