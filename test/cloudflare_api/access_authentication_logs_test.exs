defmodule CloudflareApi.AccessAuthenticationLogsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessAuthenticationLogs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/logs/access_requests?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"status" => "allow"}]}}}
    end)

    assert {:ok, [_]} = AccessAuthenticationLogs.list(client, "acc", per_page: 10)
  end
end
