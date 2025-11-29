defmodule CloudflareApi.SecretsStoreTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecretsStore

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "quota/2 returns usage info", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/secrets_store/quota"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"used" => 3}}}}
    end)

    assert {:ok, %{"used" => 3}} = SecretsStore.quota(client, "acc")
  end

  test "list_stores/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url =~
               "https://api.cloudflare.com/client/v4/accounts/acc/secrets_store/stores?order=name&per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "store"}]}}}
    end)

    assert {:ok, [%{"id" => "store"}]} =
             SecretsStore.list_stores(client, "acc", order: "name", per_page: 10)
  end

  test "create_stores/3 normalizes map payloads", %{client: client} do
    params = %{"name" => "default", "description" => "demo"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == [params]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [params]}}}
    end)

    assert {:ok, [^params]} = SecretsStore.create_stores(client, "acc", params)
  end

  test "delete_store/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 13}]}}}
    end)

    assert {:error, [%{"code" => 13}]} = SecretsStore.delete_store(client, "acc", "store")
  end

  test "list_secrets/4 passes through query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/secrets_store/stores/store/secrets?scopes=kv"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "API_KEY"}]}}}
    end)

    assert {:ok, [%{"name" => "API_KEY"}]} =
             SecretsStore.list_secrets(client, "acc", "store", scopes: "kv")
  end

  test "create_secrets/4 posts list payloads", %{client: client} do
    payload = [%{"name" => "API_KEY", "text" => "value"}]

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = SecretsStore.create_secrets(client, "acc", "store", payload)
  end

  test "delete_secrets/4 accepts map payloads", %{client: client} do
    payload = %{"name" => "stale"}

    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == [payload]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [payload]}}}
    end)

    assert {:ok, [^payload]} = SecretsStore.delete_secrets(client, "acc", "store", payload)
  end

  test "get_secret/5 targets the resource path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/secrets_store/stores/store/secrets/sec%2Fid"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "sec/id"}}}}
    end)

    assert {:ok, %{"id" => "sec/id"}} =
             SecretsStore.get_secret(client, "acc", "store", "sec/id")
  end

  test "update_secret/5 posts body", %{client: client} do
    payload = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} =
             SecretsStore.update_secret(client, "acc", "store", "sec", payload)
  end

  test "duplicate_secret/5 sends payload", %{client: client} do
    payload = %{"name" => "copy"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/secrets_store/stores/store/secrets/sec/duplicate"

      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} =
             SecretsStore.duplicate_secret(client, "acc", "store", "sec", payload)
  end

  test "delete_secret/5 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} =
             SecretsStore.delete_secret(client, "acc", "store", "sec")
  end
end
