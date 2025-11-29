defmodule CloudflareApi.RadarTcpResetsTimeoutsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarTcpResetsTimeouts

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/2 hits summary endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/tcp_resets_timeouts/summary"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"metric" => 10}}}}
    end)

    assert {:ok, %{"metric" => 10}} = RadarTcpResetsTimeouts.summary(client)
  end

  test "timeseries_groups/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 21}]}}}
    end)

    assert {:error, [%{"code" => 21}]} = RadarTcpResetsTimeouts.timeseries_groups(client)
  end
end
