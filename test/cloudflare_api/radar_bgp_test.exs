defmodule CloudflareApi.RadarBgpTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarBgp

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "hijacks_events/2 hits hijacks endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/bgp/hijacks/events"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"event" => "h"}]}}}
    end)

    assert {:ok, [%{"event" => "h"}]} = RadarBgp.hijacks_events(client)
  end

  test "routes_realtime/2 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/bgp/routes/realtime?page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"route" => "x"}]}}}
    end)

    assert {:ok, [%{"route" => "x"}]} = RadarBgp.routes_realtime(client, page: 2)
  end

  test "top_prefixes/2 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} = RadarBgp.top_prefixes(client)
  end
end
