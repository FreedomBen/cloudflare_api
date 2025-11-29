defmodule CloudflareApi.RadarBotsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarBots

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "overview/2 fetches overview", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/bots"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"summary" => "ok"}}}}
    end)

    assert {:ok, %{"summary" => "ok"}} = RadarBots.overview(client)
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/bots/summary/continent"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "continent"}]}}}
    end)

    assert {:ok, [%{"dimension" => "continent"}]} = RadarBots.summary(client, "continent")
  end

  test "get_bot/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 101}]}}}
    end)

    assert {:error, [%{"code" => 101}]} = RadarBots.get_bot(client, "foo")
  end
end
