defmodule CloudflareApi.CategoryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Category

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 includes datasetIds query", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/categories?datasetIds=one&datasetIds=two"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cat"}]}}}
    end)

    assert {:ok, [_]} = Category.list(client, "acc", datasetIds: ["one", "two"])
  end

  test "catalog/2 fetches catalog list", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/categories/catalog"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Category.catalog(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "cat", "killChain" => 1}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/categories/create"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Category.create(client, "acc", params)
  end

  test "update_patch/4 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/categories/cat"

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 1111, "message" => "bad"}]}
       }}
    end)

    assert {:error, [%{"code" => 1111, "message" => "bad"}]} =
             Category.update_patch(client, "acc", "cat", %{})
  end
end
