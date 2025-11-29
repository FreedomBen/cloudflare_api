defmodule CloudflareApi.NotificationWebhooksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.NotificationWebhooks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches webhook collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/destinations/webhooks"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "wh"}]}}}
    end)

    assert {:ok, [%{"id" => "wh"}]} = NotificationWebhooks.list(client, "acc")
  end

  test "create/3 posts JSON payload", %{client: client} do
    params = %{"name" => "Pager", "url" => "https://example"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = NotificationWebhooks.create(client, "acc", params)
  end

  test "update/4 propagates Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 44}]}}}
    end)

    assert {:error, [%{"code" => 44}]} =
             NotificationWebhooks.update(client, "acc", "wh", %{"name" => "bad"})
  end

  test "get/3 returns webhook", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/alerting/v3/destinations/webhooks/wh"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "wh"}}}}
    end)

    assert {:ok, %{"id" => "wh"}} = NotificationWebhooks.get(client, "acc", "wh")
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = NotificationWebhooks.delete(client, "acc", "wh")
  end
end
