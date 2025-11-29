defmodule CloudflareApi.AccessReusablePoliciesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessReusablePolicies

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/policies?per_page=4"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "policy"}]}}}
    end)

    assert {:ok, [_]} = AccessReusablePolicies.list(client, "acc", per_page: 4)
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"name" => "policy"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessReusablePolicies.create(client, "acc", params)
  end
end
