defmodule CloudflareApi.AiGatewayLogsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AiGatewayLogs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/logs?per_page=25"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "log"}]}}}
    end)

    assert {:ok, [%{"id" => "log"}]} =
             AiGatewayLogs.list(client, "acc", "gw", per_page: 25)
  end

  test "delete_all/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert body == "{}"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = AiGatewayLogs.delete_all(client, "acc", "gw")
  end

  test "update/5 handles errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             AiGatewayLogs.update(client, "acc", "gw", "log", %{"notes" => "foo"})
  end

  test "get_request/4 hits request endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/ai-gateway/gateways/gw/logs/log/request"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"body" => "req"}}}}
    end)

    assert {:ok, %{"body" => "req"}} = AiGatewayLogs.get_request(client, "acc", "gw", "log")
  end
end
