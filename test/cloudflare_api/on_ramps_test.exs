defmodule CloudflareApi.OnRampsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.OnRamps

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/onramps?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "onr"}]}}}
    end)

    assert {:ok, [%{"id" => "onr"}]} = OnRamps.list(client, "acc", per_page: 10)
  end

  test "apply_changes/4 posts JSON body", %{client: client} do
    params = %{"plan_id" => "123"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/onramps/onr/apply"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} = OnRamps.apply_changes(client, "acc", "onr", params)
  end

  test "update_magic_wan_address_space/3 sends PUT body", %{client: client} do
    params = %{"prefixes" => ["10.0.0.0/8"]}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/onramps/magic_wan_address_space"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = OnRamps.update_magic_wan_address_space(client, "acc", params)
  end

  test "patch/4 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 888}]}}}
    end)

    assert {:error, [%{"code" => 888}]} = OnRamps.patch(client, "acc", "onr", %{})
  end
end
