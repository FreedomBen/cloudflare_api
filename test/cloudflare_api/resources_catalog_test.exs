defmodule CloudflareApi.ResourcesCatalogTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ResourcesCatalog

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches resources", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/resources"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "res"}]}}}
    end)

    assert {:ok, [%{"id" => "res"}]} = ResourcesCatalog.list(client, "acc")
  end

  test "export/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/cloud/resources/export?format=json"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"url" => "https://"}}}}
    end)

    assert {:ok, %{"url" => "https://"}} = ResourcesCatalog.export(client, "acc", format: "json")
  end

  test "policy_preview/3 posts payload", %{client: client} do
    params = %{"policy" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"preview" => true}}}}
    end)

    assert {:ok, %{"preview" => true}} = ResourcesCatalog.policy_preview(client, "acc", params)
  end

  test "get/4 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 5}]}}}
    end)

    assert {:error, [%{"code" => 5}]} = ResourcesCatalog.get(client, "acc", "missing")
  end
end
