defmodule CloudflareApi.MagicInterconnectsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicInterconnects

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 requests interconnect collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cf_interconnects?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ic"}]}}}
    end)

    assert {:ok, [%{"id" => "ic"}]} = MagicInterconnects.list(client, "acc", page: 1)
  end

  test "update_many/3 PUTs JSON body", %{client: client} do
    params = %{"interconnects" => [%{"id" => "ic", "state" => "active"}]}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicInterconnects.update_many(client, "acc", params)
  end

  test "get/3 hits the interconnect detail endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/cf_interconnects/ic"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ic"}}}}
    end)

    assert {:ok, %{"id" => "ic"}} = MagicInterconnects.get(client, "acc", "ic")
  end

  test "update/4 surfaces failures", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 9999}]}}}
    end)

    assert {:error, [%{"code" => 9999}]} =
             MagicInterconnects.update(client, "acc", "ic", %{"name" => "new"})
  end
end
