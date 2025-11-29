defmodule CloudflareApi.RadarOriginsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarOrigins

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/origins/summary/continent"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "continent"}]}}}
    end)

    assert {:ok, [%{"dimension" => "continent"}]} = RadarOrigins.summary(client, "continent")
  end

  test "get/3 builds slug path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/origins/cdn"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"slug" => "cdn"}}}}
    end)

    assert {:ok, %{"slug" => "cdn"}} = RadarOrigins.get(client, "cdn")
  end

  test "timeseries/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 81}]}}}
    end)

    assert {:error, [%{"code" => 81}]} = RadarOrigins.timeseries(client)
  end
end
