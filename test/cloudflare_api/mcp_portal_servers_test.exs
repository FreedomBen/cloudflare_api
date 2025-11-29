defmodule CloudflareApi.McpPortalServersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.McpPortalServers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/ai-controls/mcp/servers?per_page=20"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"hostname" => "srv"}]}}}
    end)

    assert {:ok, [%{"hostname" => "srv"}]} = McpPortalServers.list(client, "acc", per_page: 20)
  end

  test "sync/3 posts empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/ai-controls/mcp/servers/srv/sync"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} = McpPortalServers.sync(client, "acc", "srv")
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"hostname" => "srv", "url" => "https://example"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = McpPortalServers.create(client, "acc", params)
  end

  test "update/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 9001}]}}}
    end)

    assert {:error, [%{"code" => 9001}]} =
             McpPortalServers.update(client, "acc", "srv", %{"hostname" => "other"})
  end
end
