defmodule CloudflareApi.RadarTrafficAnomaliesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarTrafficAnomalies

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches anomalies", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/traffic_anomalies"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "evt"}]}}}
    end)

    assert {:ok, [%{"id" => "evt"}]} = RadarTrafficAnomalies.list(client)
  end

  test "top_locations/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 2}]}}}
    end)

    assert {:error, [%{"code" => 2}]} = RadarTrafficAnomalies.top_locations(client)
  end
end
