defmodule CloudflareApi.ZeroTrustListsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustLists

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/lists?type=ip"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = ZeroTrustLists.list(client, "acc", type: "ip")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "blocked"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/lists"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustLists.create(client, "acc", params)
  end

  test "delete/4 issues body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/lists/list%2F1"

      assert Jason.decode!(body) == %{"force" => true}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustLists.delete(client, "acc", "list/1", %{"force" => true})
  end

  test "get/3 fetches list", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/lists/list%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "list/1"}}}}
    end)

    assert {:ok, %{"id" => "list/1"}} =
             ZeroTrustLists.get(client, "acc", "list/1")
  end

  test "patch/update list", %{client: client} do
    params = %{"name" => "patched"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/lists/list"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustLists.patch(client, "acc", "list", params)

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/lists/list"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustLists.update(client, "acc", "list", params)
  end

  test "list_items/4 handles pagination", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/lists/list/items?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustLists.list_items(client, "acc", "list", page: 2)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 21}]}}}
    end)

    assert {:error, [_]} = ZeroTrustLists.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
