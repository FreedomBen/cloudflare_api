defmodule CloudflareApi.RadarLayer3AttacksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarLayer3Attacks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/attacks/layer3/summary/vector"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "vector"}]}}}
    end)

    assert {:ok, [%{"dimension" => "vector"}]} = RadarLayer3Attacks.summary(client, "vector")
  end

  test "top_locations/3 handles origin/target", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/attacks/layer3/top/locations/origin"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"location" => "US"}]}}}
    end)

    assert {:ok, [%{"location" => "US"}]} = RadarLayer3Attacks.top_locations(client, :origin)
  end

  test "timeseries_group/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} = RadarLayer3Attacks.timeseries_group(client, "bitrate")
  end
end
