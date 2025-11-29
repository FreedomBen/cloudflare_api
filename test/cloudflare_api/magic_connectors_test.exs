defmodule CloudflareApi.MagicConnectorsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicConnectors

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches connectors", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/magic/connectors"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicConnectors.list(client, "acc")
  end

  test "create/3 posts connector definition", %{client: client} do
    params = %{"name" => "connector-1"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicConnectors.create(client, "acc", params)
  end

  test "list_events/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)
      assert path == "/client/v4/accounts/acc/magic/connectors/conn/telemetry/events"
      assert URI.decode_query(query) == %{"from" => "1", "to" => "2", "limit" => "10"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"events" => []}}}}
    end)

    assert {:ok, %{"events" => []}} =
             MagicConnectors.list_events(client, "acc", "conn",
               from: "1",
               to: "2",
               limit: "10"
             )
  end

  test "get_event/5 fetches single event", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/connectors/conn/telemetry/events/1700000000.1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "evt"}}}}
    end)

    assert {:ok, %{"id" => "evt"}} =
             MagicConnectors.get_event(client, "acc", "conn", 1_700_000_000, 1)
  end

  test "list_snapshots/4 adds pagination query", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/connectors/conn/telemetry/snapshots?cursor=abc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = MagicConnectors.list_snapshots(client, "acc", "conn", cursor: "abc")
  end

  test "delete/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 9100}]}}}
    end)

    assert {:error, [%{"code" => 9100}]} = MagicConnectors.delete(client, "acc", "conn")
  end
end
