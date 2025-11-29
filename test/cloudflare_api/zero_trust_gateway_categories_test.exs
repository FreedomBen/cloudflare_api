defmodule CloudflareApi.ZeroTrustGatewayCategoriesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustGatewayCategories

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches categories", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/categories"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"category" => "Adult"}]}}}
    end)

    assert {:ok, [_]} = ZeroTrustGatewayCategories.list(client, "acc")
  end

  test "handles API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 8}]}}}
    end)

    assert {:error, [_]} = ZeroTrustGatewayCategories.list(client, "acc")
  end
end
