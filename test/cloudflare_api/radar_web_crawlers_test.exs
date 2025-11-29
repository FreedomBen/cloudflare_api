defmodule CloudflareApi.RadarWebCrawlersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarWebCrawlers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 hits summary path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/bots/crawlers/summary/device_type"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "device_type"}]}}}
    end)

    assert {:ok, [%{"dimension" => "device_type"}]} =
             RadarWebCrawlers.summary(client, "device_type")
  end

  test "timeseries_group/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9}]}}}
    end)

    assert {:error, [%{"code" => 9}]} = RadarWebCrawlers.timeseries_group(client, "bot_class")
  end
end
