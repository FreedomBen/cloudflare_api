defmodule CloudflareApi.AccountResourceGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountResourceGroups

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 sends JSON", %{client: client} do
    params = %{"name" => "group"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccountResourceGroups.create(client, "acc", params)
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/iam/resource_groups?per_page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rg"}]}}}
    end)

    assert {:ok, [_]} = AccountResourceGroups.list(client, "acc", per_page: 1)
  end
end
