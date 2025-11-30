defmodule CloudflareApi.RadarHttpTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarHttp

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 hits summary endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/http/summary/ip_version"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "ip_version"}]}}}
    end)

    assert {:ok, [%{"dimension" => "ip_version"}]} = RadarHttp.summary(client, "ip_version")
  end

  test "top_ases_by/4 encodes dimension/value", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/http/top/ases/ip_version/IPv6"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"asn" => 13_335}]}}}
    end)

    assert {:ok, [%{"asn" => 13_335}]} = RadarHttp.top_ases_by(client, "ip_version", "IPv6")
  end

  test "top_locations/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} = RadarHttp.top_locations(client)
  end
end
