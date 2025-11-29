defmodule CloudflareApi.RadarDomainsRankingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarDomainsRanking

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "top_domains/2 fetches top list", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/ranking/top"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"domain" => "example.com"}]}}}
    end)

    assert {:ok, [%{"domain" => "example.com"}]} = RadarDomainsRanking.top_domains(client)
  end

  test "timeseries_groups/2 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/ranking/timeseries_groups?continent=EU"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"continent" => "EU"}]}}}
    end)

    assert {:ok, [%{"continent" => "EU"}]} =
             RadarDomainsRanking.timeseries_groups(client, continent: "EU")
  end

  test "domain_details/3 surface API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9}]}}}
    end)

    assert {:error, [%{"code" => 9}]} = RadarDomainsRanking.domain_details(client, "bad.com")
  end
end
