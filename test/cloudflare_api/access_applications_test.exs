defmodule CloudflareApi.AccessApplicationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessApplications

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/apps?per_page=5"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "app"}]}}}
    end)

    assert {:ok, [_]} = AccessApplications.list(client, "acc", per_page: 5)
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"name" => "app"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessApplications.create(client, "acc", params)
  end

  test "revoke_tokens/3 hits revoke endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/apps/app/revoke_tokens"

      assert body == "{}"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"revoked" => true}}}}
    end)

    assert {:ok, %{"revoked" => true}} = AccessApplications.revoke_tokens(client, "acc", "app")
  end

  test "patch_settings/4 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/apps/app/settings"
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 200}]}}}
    end)

    assert {:error, [%{"code" => 200}]} =
             AccessApplications.patch_settings(client, "acc", "app", %{})
  end
end
