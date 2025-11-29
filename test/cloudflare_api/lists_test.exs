defmodule CloudflareApi.ListsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Lists

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches account lists", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Lists.list(client, "acc")
  end

  test "create/3 posts list definition", %{client: client} do
    params = %{"name" => "allowlist", "kind" => "ip", "description" => "trusted hosts"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Lists.create(client, "acc", params)
  end

  test "get/3 fetches a list", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "list123"}}}}
    end)

    assert {:ok, %{"id" => "list123"}} = Lists.get(client, "acc", "list123")
  end

  test "update/4 puts description changes", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :put, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Lists.update(client, "acc", "list123", params)
  end

  test "delete/3 sends an empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "list123"}}}}
    end)

    assert {:ok, %{"id" => "list123"}} = Lists.delete(client, "acc", "list123")
  end

  test "get_items/4 encodes pagination query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123/items?cursor=abc&per_page=50"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Lists.get_items(client, "acc", "list123", cursor: "abc", per_page: 50)
  end

  test "create_items/4 posts bulk append request", %{client: client} do
    params = %{"items" => [%{"value" => "192.0.2.1"}]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"operation_id" => "op123", "status" => "pending"}}
       }}
    end)

    assert {:ok, %{"operation_id" => "op123"}} =
             Lists.create_items(client, "acc", "list123", params)
  end

  test "replace_items/4 posts full replacement payload", %{client: client} do
    params = %{"items" => [%{"value" => "example.com"}]}

    mock(fn %Tesla.Env{method: :put, body: body, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123/items"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"operation_id" => "op456"}}}}
    end)

    assert {:ok, %{"operation_id" => "op456"}} =
             Lists.replace_items(client, "acc", "list123", params)
  end

  test "delete_items/4 surfaces Cloudflare errors", %{client: client} do
    params = %{"items" => [%{"id" => "item123"}]}

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123/items"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1007}]}}}
    end)

    assert {:error, [%{"code" => 1007}]} =
             Lists.delete_items(client, "acc", "list123", params)
  end

  test "get_item/4 fetches a single item", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/list123/items/item456"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "item456"}}}}
    end)

    assert {:ok, %{"id" => "item456"}} =
             Lists.get_item(client, "acc", "list123", "item456")
  end

  test "get_bulk_operation/3 returns status", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/rules/lists/bulk_operations/op123"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"operation_id" => "op123", "status" => "running"}}
       }}
    end)

    assert {:ok, %{"operation_id" => "op123"}} =
             Lists.get_bulk_operation(client, "acc", "op123")
  end
end
