defmodule CloudflareApi.AccountUserGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountUserGroups

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/iam/user_groups?per_page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "grp"}]}}}
    end)

    assert {:ok, [_]} = AccountUserGroups.list(client, "acc", per_page: 2)
  end

  test "add_member/4 sends JSON", %{client: client} do
    params = %{"email" => "user@example.com"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/iam/user_groups/grp/members"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccountUserGroups.add_member(client, "acc", "grp", params)
  end

  test "delete_member/4 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             AccountUserGroups.delete_member(client, "acc", "grp", "mem")
  end
end
