defmodule CloudflareApi.RadarIpTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarIp

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "lookup/2 fetches IP metadata", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/entities/ip?ip=1.1.1.1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ip" => "1.1.1.1"}}}}
    end)

    assert {:ok, %{"ip" => "1.1.1.1"}} = RadarIp.lookup(client, ip: "1.1.1.1")
  end

  test "lookup/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 19}]}}}
    end)

    assert {:error, [%{"code" => 19}]} = RadarIp.lookup(client)
  end
end
