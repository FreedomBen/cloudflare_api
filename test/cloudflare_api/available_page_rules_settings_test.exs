defmodule CloudflareApi.AvailablePageRulesSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AvailablePageRulesSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches settings for a zone", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/pagerules/settings"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "browser_cache_ttl"}]}
       }}
    end)

    assert {:ok, [%{"id" => "browser_cache_ttl"}]} =
             AvailablePageRulesSettings.list(client, "zone")
  end

  test "list/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 403,
           body: %{"errors" => [%{"code" => 9103, "message" => "forbidden"}]}
       }}
    end)

    assert {:error, [%{"code" => 9103, "message" => "forbidden"}]} =
             AvailablePageRulesSettings.list(client, "zone")
  end
end
