defmodule CloudflareApi.DurableObjectsNamespaceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DurableObjectsNamespace

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_namespaces/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/durable_objects/namespaces?per_page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ns"}]}}}
    end)

    assert {:ok, [_]} =
             DurableObjectsNamespace.list_namespaces(client, "acc", per_page: 2)
  end

  test "list_objects/4 hits objects endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/durable_objects/namespaces/ns/objects"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "obj"}]}}}
    end)

    assert {:ok, [_]} =
             DurableObjectsNamespace.list_objects(client, "acc", "ns")
  end

  test "list_objects/4 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             DurableObjectsNamespace.list_objects(client, "acc", "ns", per_page: 10)
  end
end
