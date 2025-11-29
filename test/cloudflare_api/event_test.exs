defmodule CloudflareApi.EventTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Event

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches events with filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events?since=2024-01-01"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "event"}]}}}
    end)

    assert {:ok, [_]} = Event.list(client, "acc", since: "2024-01-01")
  end

  test "aggregate/3 hits aggregate endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/aggregate?group_by=type"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"totals" => []}}}}
    end)

    assert {:ok, %{"totals" => []}} =
             Event.aggregate(client, "acc", group_by: "type")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "event"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             Event.create(client, "acc", params)
  end

  test "get_event/4 retrieves event", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/events/evt"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "evt"}}}}
    end)

    assert {:ok, %{"id" => "evt"}} =
             Event.get_event(client, "acc", "ds", "evt")
  end

  test "move_to_dataset/4 posts JSON body", %{client: client} do
    params = %{"events" => ["evt1"], "target_dataset_id" => "dst"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/move"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"moved" => true}}}}
    end)

    assert {:ok, %{"moved" => true}} =
             Event.move_to_dataset(client, "acc", "ds", params)
  end

  test "delete_event/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/event"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             Event.delete_event(client, "acc", "event")
  end

  test "add_event_tag/4 posts tag params", %{client: client} do
    params = %{"tag" => "phishing"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/event_tag/event_id/create"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             Event.add_event_tag(client, "acc", "event_id", params)
  end

  test "create_relationships/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             Event.create_relationships(client, "acc", %{"relation" => %{}})
  end
end
