defmodule CloudflareApi.AccessPolicyTesterTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessPolicyTester

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create_test/3 sends JSON", %{client: client} do
    params = %{"name" => "test"}

    mock(fn %Tesla.Env{
              method: :post,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/access/policy-tests",
              body: body
            } = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessPolicyTester.create_test(client, "acc", params)
  end

  test "list_test_users/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/policy-tests/test/users?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"email" => "user"}]}}}
    end)

    assert {:ok, [_]} = AccessPolicyTester.list_test_users(client, "acc", "test", page: 2)
  end
end
