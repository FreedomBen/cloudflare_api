defmodule CloudflareApi.AccountMembersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountMembers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/members?per_page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "mem"}]}}}
    end)

    assert {:ok, [_]} = AccountMembers.list(client, "acc", per_page: 1)
  end

  test "add/3 sends JSON", %{client: client} do
    params = %{"email" => "user@example.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccountMembers.add(client, "acc", params)
  end

  test "remove/3 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"removed" => true}}}}
    end)

    assert {:ok, %{"removed" => true}} = AccountMembers.remove(client, "acc", "mem")
  end
end
