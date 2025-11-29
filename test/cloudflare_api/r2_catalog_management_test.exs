defmodule CloudflareApi.R2CatalogManagementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.R2CatalogManagement

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 requests catalog collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/r2-catalog?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "bucket"}]}}}
    end)

    assert {:ok, [%{"name" => "bucket"}]} = R2CatalogManagement.list(client, "acc", page: 1)
  end

  test "enable/3 posts empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = R2CatalogManagement.enable(client, "acc", "bucket")
  end

  test "get/3 bubbles CF errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} = R2CatalogManagement.get(client, "acc", "missing")
  end
end
