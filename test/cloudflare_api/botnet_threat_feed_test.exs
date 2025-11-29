defmodule CloudflareApi.BotnetThreatFeedTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.BotnetThreatFeed

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_asn_configs/2 lists configured ASNs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/botnet_feed/configs/asn"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"asn" => 13335}]}
       }}
    end)

    assert {:ok, [%{"asn" => 13335}]} = BotnetThreatFeed.list_asn_configs(client, "acc")
  end

  test "day_report/4 encodes optional date filter", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/botnet_feed/asn/13335/day_report?date=2024-01-01"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"requests" => 10}}
       }}
    end)

    assert {:ok, %{"requests" => 10}} =
             BotnetThreatFeed.day_report(client, "acc", "13335", date: "2024-01-01")
  end

  test "full_report/3 hits the full report endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/botnet_feed/asn/13335/full_report"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"report" => []}}
       }}
    end)

    assert {:ok, %{"report" => []}} = BotnetThreatFeed.full_report(client, "acc", "13335")
  end

  test "delete_asn_config/3 returns API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/botnet_feed/configs/asn/13335"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "missing"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "missing"}]} =
             BotnetThreatFeed.delete_asn_config(client, "acc", "13335")
  end
end
