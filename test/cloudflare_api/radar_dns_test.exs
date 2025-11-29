defmodule CloudflareApi.RadarDnsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarDns

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 encodes dimension and opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/dns/summary/cache_hit?continent=EU"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "cache_hit"}]}}}
    end)

    assert {:ok, [%{"dimension" => "cache_hit"}]} =
             RadarDns.summary(client, "cache_hit", continent: "EU")
  end

  test "timeseries_group/3 builds group path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/dns/timeseries_groups/protocol"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "protocol"}]}}}
    end)

    assert {:ok, [%{"dimension" => "protocol"}]} = RadarDns.timeseries_group(client, "protocol")
  end

  test "top_ases/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 502, body: %{"errors" => [%{"code" => 13}]}}}
    end)

    assert {:error, [%{"code" => 13}]} = RadarDns.top_ases(client)
  end
end
