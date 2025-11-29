defmodule CloudflareApi.RadarGeolocationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarGeolocations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches geolocations", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/geolocations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "US"}]}}}
    end)

    assert {:ok, [%{"id" => "US"}]} = RadarGeolocations.list(client)
  end

  test "get/3 encodes geo_id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/geolocations/US"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "US"}}}}
    end)

    assert {:ok, %{"id" => "US"}} = RadarGeolocations.get(client, "US")
  end

  test "list/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 11}]}}}
    end)

    assert {:error, [%{"code" => 11}]} = RadarGeolocations.list(client)
  end
end
