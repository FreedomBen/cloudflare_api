defmodule CloudflareApi.ResourceSharingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ResourceSharing

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits shares endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/shares"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "share"}]}}}
    end)

    assert {:ok, [%{"id" => "share"}]} = ResourceSharing.list(client, "acc")
  end

  test "create_recipient/4 posts payload", %{client: client} do
    params = %{"email" => "user@example.com"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/shares/share/recipients"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rec"}}}}
    end)

    assert {:ok, %{"id" => "rec"}} = ResourceSharing.create_recipient(client, "acc", "share", params)
  end

  test "delete_resource/4 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             ResourceSharing.delete_resource(client, "acc", "share", "res")
  end

  test "organization_shares/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/organizations/org/shares?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "share"}]}}}
    end)

    assert {:ok, [%{"id" => "share"}]} = ResourceSharing.organization_shares(client, "org", page: 1)
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} = ResourceSharing.get(client, "acc", "missing")
  end
end
