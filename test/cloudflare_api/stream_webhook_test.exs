defmodule CloudflareApi.StreamWebhookTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamWebhook

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches webhook configuration", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/stream/webhook"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"url" => "https://hook"}}}}
    end)

    assert {:ok, %{"url" => "https://hook"}} = StreamWebhook.get(client, "acc")
  end

  test "upsert/3 posts JSON body", %{client: client} do
    params = %{"notificationUrl" => "https://hook"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = StreamWebhook.upsert(client, "acc", params)
  end

  test "delete/2 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 123}]}}}
    end)

    assert {:error, [%{"code" => 123}]} = StreamWebhook.delete(client, "acc")
  end
end
