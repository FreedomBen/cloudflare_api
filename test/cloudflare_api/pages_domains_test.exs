defmodule CloudflareApi.PagesDomainsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PagesDomains

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 hits the domains collection with query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/pages/projects/proj/domains?per_page=50"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "example.com"}]}}}
    end)

    assert {:ok, [%{"name" => "example.com"}]} =
             PagesDomains.list(client, "acc", "proj", per_page: 50)
  end

  test "create/4 posts JSON body", %{client: client} do
    params = %{"name" => "app.example.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = PagesDomains.create(client, "acc", "proj", params)
  end

  test "update/4 patches without payload", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "pending"}}}}
    end)

    assert {:ok, %{"status" => "pending"}} = PagesDomains.update(client, "acc", "proj", "app")
  end

  test "delete/4 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1001}]}}}
    end)

    assert {:error, [%{"code" => 1001}]} = PagesDomains.delete(client, "acc", "proj", "app")
  end
end
