defmodule CloudflareApi.AccountCustomNameserversTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountCustomNameservers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits account endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: "https://api.cloudflare.com/client/v4/accounts/acc/custom_ns"} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = AccountCustomNameservers.list(client, "acc")
  end

  test "update_zone_usage/3 sends JSON", %{client: client} do
    params = %{"enabled" => true}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/custom_ns"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             AccountCustomNameservers.update_zone_usage(client, "zone", params)
  end
end
