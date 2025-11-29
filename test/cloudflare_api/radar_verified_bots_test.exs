defmodule CloudflareApi.RadarVerifiedBotsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarVerifiedBots

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "top_bots/2 fetches list", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/verified_bots/top/bots"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Bot"}]}}}
    end)

    assert {:ok, [%{"name" => "Bot"}]} = RadarVerifiedBots.top_bots(client)
  end

  test "top_categories/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [%{"code" => 5}]} = RadarVerifiedBots.top_categories(client)
  end
end
