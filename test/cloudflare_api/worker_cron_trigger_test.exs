defmodule CloudflareApi.WorkerCronTriggerTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerCronTrigger

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches cron schedules", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/schedules"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"cron" => "* * * * *"}]}}}
    end)

    assert {:ok, [_]} = WorkerCronTrigger.list(client, "acc", "script")
  end

  test "update/4 replaces cron schedules", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/schedules"
      assert Jason.decode!(body) == %{"schedules" => [%{"cron" => "0 * * * *"}]}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    params = %{"schedules" => [%{"cron" => "0 * * * *"}]}
    assert {:ok, %{"ok" => true}} = WorkerCronTrigger.update(client, "acc", "script", params)
  end

  test "handles API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 11}]}}}
    end)

    assert {:error, [%{"code" => 11}]} =
             WorkerCronTrigger.update(client, "acc", "script", %{})
  end
end
