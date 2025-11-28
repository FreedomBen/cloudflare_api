defmodule CloudflareApi.AccessAppPoliciesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessAppPolicies

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/apps/app/policies?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pol"}]}}}
    end)

    assert {:ok, [_]} =
             AccessAppPolicies.list(client, "acc", "app", per_page: 10)
  end

  test "create/4 sends JSON body", %{client: client} do
    params = %{"name" => "policy"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessAppPolicies.create(client, "acc", "app", params)
  end

  test "make_reusable/4 hits endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/apps/app/policies/pol/make_reusable"

      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"reusable" => true}}}}
    end)

    assert {:ok, %{"reusable" => true}} =
             AccessAppPolicies.make_reusable(client, "acc", "app", "pol")
  end
end
