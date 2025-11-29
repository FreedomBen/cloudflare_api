defmodule CloudflareApi.RadarAnnotationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarAnnotations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches annotations", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/annotations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "event"}]}}}
    end)

    assert {:ok, [%{"id" => "event"}]} = RadarAnnotations.list(client)
  end

  test "outage_locations/2 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/annotations/outages/locations?limit=5"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"location" => "US"}]}}}
    end)

    assert {:ok, [%{"location" => "US"}]} = RadarAnnotations.outage_locations(client, limit: 5)
  end

  test "outages/2 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 8}]}}}
    end)

    assert {:error, [%{"code" => 8}]} = RadarAnnotations.outages(client)
  end
end
