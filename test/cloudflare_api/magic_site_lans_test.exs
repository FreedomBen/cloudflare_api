defmodule CloudflareApi.MagicSiteLansTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicSiteLans

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/4 fetches lan details", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/sites/site/lans/lan"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "lan"}}}}
    end)

    assert {:ok, %{"id" => "lan"}} = MagicSiteLans.get(client, "acc", "site", "lan")
  end

  test "update/5 sends PUT", %{client: client} do
    params = %{"name" => "LAN"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MagicSiteLans.update(client, "acc", "site", "lan", params)
  end
end
