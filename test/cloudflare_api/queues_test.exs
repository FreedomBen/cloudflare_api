defmodule CloudflareApi.QueuesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Queues

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_subscriptions/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/event_subscriptions/subscriptions?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "sub"}]}}}
    end)

    assert {:ok, [%{"id" => "sub"}]} = Queues.list_subscriptions(client, "acc", page: 1)
  end

  test "create/3 posts queue payload", %{client: client} do
    params = %{"name" => "queue"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/queues"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "queue"}}}}
    end)

    assert {:ok, %{"id" => "queue"}} = Queues.create(client, "acc", params)
  end

  test "create_consumer/4 posts JSON body", %{client: client} do
    params = %{"script" => "worker"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/queues/q/consumers"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cons"}}}}
    end)

    assert {:ok, %{"id" => "cons"}} = Queues.create_consumer(client, "acc", "q", params)
  end

  test "push_message/4 posts body to messages endpoint", %{client: client} do
    params = %{"message" => %{"body" => "hi"}}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/queues/q/messages"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"queued" => 1}}}}
    end)

    assert {:ok, %{"queued" => 1}} = Queues.push_message(client, "acc", "q", params)
  end

  test "ack_messages/4 posts ACK payload", %{client: client} do
    params = %{"acks" => [%{"id" => "msg"}]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/queues/q/messages/ack"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"acked" => 1}}}}
    end)

    assert {:ok, %{"acked" => 1}} = Queues.ack_messages(client, "acc", "q", params)
  end

  test "purge/4 defaults to empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "running"}}}}
    end)

    assert {:ok, %{"status" => "running"}} = Queues.purge(client, "acc", "q")
  end

  test "get/3 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 13}]}}}
    end)

    assert {:error, [%{"code" => 13}]} = Queues.get(client, "acc", "missing")
  end
end
