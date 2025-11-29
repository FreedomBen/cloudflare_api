defmodule CloudflareApi.AccountLoadBalancerSearchTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountLoadBalancerSearch

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "search/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/load_balancers/search?q=test"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"type" => "pool"}]}}}
    end)

    assert {:ok, [_]} = AccountLoadBalancerSearch.search(client, "acc", q: "test")
  end
end
