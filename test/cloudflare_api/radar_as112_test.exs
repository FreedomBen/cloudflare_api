defmodule CloudflareApi.RadarAs112Test do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarAs112

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 hits dimension path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/as112/summary/dnssec"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "dnssec"}]}}}
    end)

    assert {:ok, [%{"dimension" => "dnssec"}]} = RadarAs112.summary(client, "dnssec")
  end

  test "top_locations_by/4 encodes dimension and value", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/as112/top/locations/ip_version/IPv6"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"location" => "US"}]}}}
    end)

    assert {:ok, [%{"location" => "US"}]} =
             RadarAs112.top_locations_by(client, "ip_version", "IPv6")
  end

  test "timeseries/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 2}]}}}
    end)

    assert {:error, [%{"code" => 2}]} = RadarAs112.timeseries(client)
  end
end
