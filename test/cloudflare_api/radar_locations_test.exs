defmodule CloudflareApi.RadarLocationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarLocations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches locations", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/entities/locations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"alpha2" => "US"}]}}}
    end)

    assert {:ok, [%{"alpha2" => "US"}]} = RadarLocations.list(client)
  end

  test "get/3 encodes location", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/entities/locations/US"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"alpha2" => "US"}}}}
    end)

    assert {:ok, %{"alpha2" => "US"}} = RadarLocations.get(client, "US")
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 3}]}}}
    end)

    assert {:error, [%{"code" => 3}]} = RadarLocations.get(client, "bad")
  end
end
