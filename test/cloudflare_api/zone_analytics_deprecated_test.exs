defmodule CloudflareApi.ZoneAnalyticsDeprecatedTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAnalyticsDeprecated

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_dashboard/3 builds URL", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/zones/zone/analytics/dashboard?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"totals" => %{}}}}}
    end)

    assert {:ok, %{"totals" => %{}}} =
             ZoneAnalyticsDeprecated.get_dashboard(client, "zone", page: 2)
  end

  test "get_colos/3 fetches colos", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/zones/zone/analytics/colos"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = ZoneAnalyticsDeprecated.get_colos(client, "zone")
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} = ZoneAnalyticsDeprecated.get_dashboard(client, "zone")
  end
end
