defmodule CloudflareApi.AccountPermissionGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountPermissionGroups

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/iam/permission_groups?per_page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pg"}]}}}
    end)

    assert {:ok, [_]} = AccountPermissionGroups.list(client, "acc", per_page: 1)
  end
end
