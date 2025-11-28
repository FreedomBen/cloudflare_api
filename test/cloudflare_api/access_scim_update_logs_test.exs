defmodule CloudflareApi.AccessScimUpdateLogsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessScimUpdateLogs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/logs/scim/updates?per_page=20"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"status" => "ok"}]}}}
    end)

    assert {:ok, [_]} = AccessScimUpdateLogs.list(client, "acc", per_page: 20)
  end
end
