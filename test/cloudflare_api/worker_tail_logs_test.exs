defmodule CloudflareApi.WorkerTailLogsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerTailLogs

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits the tails endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/tails"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "tail"}]}}}
    end)

    assert {:ok, [_]} = WorkerTailLogs.list(client, "acc", "script")
  end

  test "start/4 sends JSON", %{client: client} do
    params = %{"url" => "wss://example.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkerTailLogs.start(client, "acc", "script", params)
  end

  test "delete/4 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/tails/tail-id"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = WorkerTailLogs.delete(client, "acc", "script", "tail-id")
  end

  test "error responses bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [_]} = WorkerTailLogs.list(client, "acc", "script")
  end
end
