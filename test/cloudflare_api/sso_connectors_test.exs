defmodule CloudflareApi.SsoConnectorsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SsoConnectors

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits connectors endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/sso_connectors"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "sso"}]}}}
    end)

    assert {:ok, [%{"id" => "sso"}]} = SsoConnectors.list(client, "acc")
  end

  test "init/3 posts params", %{client: client} do
    params = %{"name" => "Okta"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "sso"}}}}
    end)

    assert {:ok, %{"id" => "sso"}} = SsoConnectors.init(client, "acc", params)
  end

  test "update_state/4 uses PATCH", %{client: client} do
    params = %{"enabled" => true}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/sso_connectors/sso"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SsoConnectors.update_state(client, "acc", "sso", params)
  end

  test "begin_verification/4 posts payload", %{client: client} do
    params = %{"saml_metadata" => "..."}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/sso_connectors/sso/begin_verification"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "pending"}}}}
    end)

    assert {:ok, %{"status" => "pending"}} =
             SsoConnectors.begin_verification(client, "acc", "sso", params)
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 8}]}}}
    end)

    assert {:error, [%{"code" => 8}]} = SsoConnectors.get(client, "acc", "missing")
  end
end
