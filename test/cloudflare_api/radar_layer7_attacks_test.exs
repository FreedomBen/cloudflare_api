defmodule CloudflareApi.RadarLayer7AttacksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarLayer7Attacks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/attacks/layer7/summary/http_method"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "http_method"}]}}}
    end)

    assert {:ok, [%{"dimension" => "http_method"}]} =
             RadarLayer7Attacks.summary(client, "http_method")
  end

  test "top_locations/3 encodes type", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/attacks/layer7/top/locations/origin"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"location" => "US"}]}}}
    end)

    assert {:ok, [%{"location" => "US"}]} = RadarLayer7Attacks.top_locations(client, :origin)
  end

  test "timeseries_group/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 88}]}}}
    end)

    assert {:error, [%{"code" => 88}]} = RadarLayer7Attacks.timeseries_group(client, "vertical")
  end
end
