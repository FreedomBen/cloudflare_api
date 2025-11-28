defmodule CloudflareApi.AccessGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessGroups

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/groups?per_page=3"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "grp"}]}}}
    end)

    assert {:ok, [_]} = AccessGroups.list(client, "acc", per_page: 3)
  end

  test "create/3 sends JSON", %{client: client} do
    params = %{"name" => "group"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessGroups.create(client, "acc", params)
  end
end
