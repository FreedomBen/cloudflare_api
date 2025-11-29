defmodule CloudflareApi.WorkersKvNamespaceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersKvNamespace

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_namespaces/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/storage/kv/namespaces?per_page=10&page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersKvNamespace.list_namespaces(client, "acc", per_page: 10, page: 2)
  end

  test "create_namespace/3 posts JSON", %{client: client} do
    params = %{"title" => "kv"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkersKvNamespace.create_namespace(client, "acc", params)
  end

  test "delete_namespace/3 issues delete with body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/storage/kv/namespaces/ns"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = WorkersKvNamespace.delete_namespace(client, "acc", "ns")
  end

  test "rename_namespace/4 sends JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == %{"title" => "new"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"title" => "new"}}}}
    end)

    assert {:ok, %{"title" => "new"}} =
             WorkersKvNamespace.rename_namespace(client, "acc", "ns", %{"title" => "new"})
  end

  test "write_bulk/4 sends entries", %{client: client} do
    entries = [%{"key" => "a", "value" => "1"}]

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/storage/kv/namespaces/ns/bulk"
      assert Jason.decode!(body) == entries
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = WorkersKvNamespace.write_bulk(client, "acc", "ns", entries)
  end

  test "delete_bulk_deprecated/4 uses DELETE body", %{client: client} do
    entries = [%{"key" => "a"}]

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/storage/kv/namespaces/ns/bulk"
      assert Jason.decode!(body) == entries
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersKvNamespace.delete_bulk_deprecated(client, "acc", "ns", entries)
  end

  test "delete_bulk/4 hits POST bulk/delete", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/storage/kv/namespaces/ns/bulk/delete"
      assert Jason.decode!(body) == [%{"key" => "a"}]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersKvNamespace.delete_bulk(client, "acc", "ns", [%{"key" => "a"}])
  end

  test "read_bulk/4 posts payload", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/storage/kv/namespaces/ns/bulk/get"
      assert Jason.decode!(body) == %{"keys" => ["a"]}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersKvNamespace.read_bulk(client, "acc", "ns", %{"keys" => ["a"]})
  end

  test "list_keys/4 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/storage/kv/namespaces/ns/keys?prefix=user&limit=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersKvNamespace.list_keys(client, "acc", "ns", prefix: "user", limit: 10)
  end

  test "read_metadata/4 hits metadata path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/storage/kv/namespaces/ns/metadata/key%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"expire" => 1}}}}
    end)

    assert {:ok, %{"expire" => 1}} =
             WorkersKvNamespace.read_metadata(client, "acc", "ns", "key/1")
  end

  test "delete_value/4 deletes key", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/storage/kv/namespaces/ns/values/name+space"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersKvNamespace.delete_value(client, "acc", "ns", "name space")
  end

  test "read_value/5 returns raw body", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/storage/kv/namespaces/ns/values/foo"

      {:ok, %Tesla.Env{env | status: 200, body: "bar"}}
    end)

    assert {:ok, "bar"} =
             WorkersKvNamespace.read_value(client, "acc", "ns", "foo")
  end

  test "write_value/7 sends headers & query", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, headers: headers, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/storage/kv/namespaces/ns/values/foo?expiration=123"

      assert body == "value"
      assert {"content-type", "application/octet-stream"} in headers
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersKvNamespace.write_value(
               client,
               "acc",
               "ns",
               "foo",
               "value",
               [expiration: 123],
               [{"content-type", "application/octet-stream"}]
             )
  end

  test "surfaced errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [_]} = WorkersKvNamespace.create_namespace(client, "acc", %{})
  end
end
