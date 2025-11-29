defmodule CloudflareApi.RadarQualityTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarQuality

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "iqi_summary/2 hits summary endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/quality/iqi/summary"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"score" => 100}}}}
    end)

    assert {:ok, %{"score" => 100}} = RadarQuality.iqi_summary(client)
  end

  test "speed_top_ases/2 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/quality/speed/top/ases?continent=EU"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"asn" => 1}]}}}
    end)

    assert {:ok, [%{"asn" => 1}]} = RadarQuality.speed_top_ases(client, continent: "EU")
  end

  test "speed_histogram/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 4}]}}}
    end)

    assert {:error, [%{"code" => 4}]} = RadarQuality.speed_histogram(client)
  end
end
