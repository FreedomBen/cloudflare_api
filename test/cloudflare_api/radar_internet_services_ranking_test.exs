defmodule CloudflareApi.RadarInternetServicesRankingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarInternetServicesRanking

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "categories/2 fetches categories", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/ranking/internet_services/categories"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "Search"}]}}}
    end)

    assert {:ok, [%{"name" => "Search"}]} = RadarInternetServicesRanking.categories(client)
  end

  test "top/2 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/ranking/internet_services/top?category=Search"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"service" => "Example"}]}}}
    end)

    assert {:ok, [%{"service" => "Example"}]} =
             RadarInternetServicesRanking.top(client, category: "Search")
  end

  test "timeseries_groups/2 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} = RadarInternetServicesRanking.timeseries_groups(client)
  end
end
