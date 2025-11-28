defmodule CloudflareApi.AccessBookmarksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessBookmarks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/bookmarks?page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "bm"}]}}}
    end)

    assert {:ok, [%{"id" => "bm"}]} = AccessBookmarks.list(client, "acc", page: 2)
  end

  test "create/4 sends JSON body", %{client: client} do
    params = %{"name" => "bookmark"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessBookmarks.create(client, "acc", "bm", params)
  end

  test "delete/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 100}]}}}
    end)

    assert {:error, [%{"code" => 100}]} = AccessBookmarks.delete(client, "acc", "bm")
  end
end
