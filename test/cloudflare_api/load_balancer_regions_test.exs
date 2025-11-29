defmodule CloudflareApi.LoadBalancerRegionsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LoadBalancerRegions

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)

      assert path ==
               "/client/v4/accounts/acc/load_balancers/regions"

      assert URI.decode_query(query) == %{"country_code_a2" => "US", "subdivision_code" => "CA"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             LoadBalancerRegions.list(client, "acc",
               country_code_a2: "US",
               subdivision_code: "CA"
             )
  end

  test "get/3 fetches region mapping", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/regions/WEU"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "WEU"}}}}
    end)

    assert {:ok, %{"id" => "WEU"}} = LoadBalancerRegions.get(client, "acc", "WEU")
  end
end
