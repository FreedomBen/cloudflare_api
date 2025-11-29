defmodule CloudflareApi.RadarAutonomousSystemsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarAutonomousSystems

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 requests ASN list", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/entities/asns"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"asn" => 13335}]}}}
    end)

    assert {:ok, [%{"asn" => 13335}]} = RadarAutonomousSystems.list(client)
  end

  test "get/3 encodes ASN", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/entities/asns/13335"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"asn" => 13335}}}}
    end)

    assert {:ok, %{"asn" => 13335}} = RadarAutonomousSystems.get(client, 13335)
  end

  test "relationships/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 33}]}}}
    end)

    assert {:error, [%{"code" => 33}]} = RadarAutonomousSystems.relationships(client, 1)
  end
end
