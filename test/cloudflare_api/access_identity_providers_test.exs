defmodule CloudflareApi.AccessIdentityProvidersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessIdentityProviders

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/identity_providers?per_page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "idp"}]}}}
    end)

    assert {:ok, [_]} = AccessIdentityProviders.list(client, "acc", per_page: 2)
  end

  test "create/3 sends JSON", %{client: client} do
    params = %{"name" => "Okta"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessIdentityProviders.create(client, "acc", params)
  end

  test "list_scim_groups/4 hits SCIM endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/identity_providers/idp/scim/groups"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"displayName" => "group"}]}}}
    end)

    assert {:ok, [_]} = AccessIdentityProviders.list_scim_groups(client, "acc", "idp")
  end
end
