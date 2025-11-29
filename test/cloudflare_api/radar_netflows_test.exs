defmodule CloudflareApi.RadarNetflowsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarNetflows

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 supports nil dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/netflows/summary"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} = RadarNetflows.summary(client)
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/netflows/summary/ip_version"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"dimension" => "ip_version"}}}}
    end)

    assert {:ok, %{"dimension" => "ip_version"}} = RadarNetflows.summary(client, "ip_version")
  end

  test "timeseries_group/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 17}]}}}
    end)

    assert {:error, [%{"code" => 17}]} = RadarNetflows.timeseries_group(client, "protocol")
  end
end
