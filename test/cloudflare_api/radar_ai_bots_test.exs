defmodule CloudflareApi.RadarAiBotsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarAiBots

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/ai/bots/summary/continent"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "continent"}]}}}
    end)

    assert {:ok, [%{"dimension" => "continent"}]} = RadarAiBots.summary(client, "continent")
  end

  test "timeseries_group_user_agent/2 hits expected path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/ai/bots/timeseries_groups/user_agent"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"user_agent" => "bot"}]}}}
    end)

    assert {:ok, [%{"user_agent" => "bot"}]} = RadarAiBots.timeseries_group_user_agent(client)
  end

  test "timeseries/2 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} = RadarAiBots.timeseries(client)
  end
end
