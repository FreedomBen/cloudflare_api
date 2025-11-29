defmodule CloudflareApi.AuditLogsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AuditLogs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_account/3 encodes provided opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/audit_logs?direction=desc&per_page=2"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"action" => "login"}]}
       }}
    end)

    assert {:ok, [%{"action" => "login"}]} =
             AuditLogs.list_account(client, "acc", direction: "desc", per_page: 2)
  end

  test "list_account_v2/3 hits the newer endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/logs/audit?cursor=next"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "log"}]}
       }}
    end)

    assert {:ok, [%{"id" => "log"}]} =
             AuditLogs.list_account_v2(client, "acc", cursor: "next")
  end

  test "list_user/1 exposes API errors", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/user/audit_logs"

      {:ok,
       %Tesla.Env{
         env
         | status: 403,
           body: %{"errors" => [%{"code" => 9100, "message" => "forbidden"}]}
       }}
    end)

    assert {:error, [%{"code" => 9100, "message" => "forbidden"}]} =
             AuditLogs.list_user(client)
  end
end
