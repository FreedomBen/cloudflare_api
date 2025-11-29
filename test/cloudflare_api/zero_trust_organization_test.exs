defmodule CloudflareApi.ZeroTrustOrganizationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustOrganization

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches organization", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/access/organizations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "org"}}}}
    end)

    assert {:ok, %{"name" => "org"}} =
             ZeroTrustOrganization.get(client, "acc")
  end

  test "create/update organization", %{client: client} do
    params = %{"name" => "org"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/access/organizations"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustOrganization.create(client, "acc", params)

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/accounts/acc/access/organizations"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustOrganization.update(client, "acc", params)
  end

  test "get/update DoH settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) ==
               "/accounts/acc/access/organizations/doh"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustOrganization.get_doh_settings(client, "acc")

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/access/organizations/doh"

      assert Jason.decode!(body) == %{"enable" => true}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enable" => true}}}}
    end)

    assert {:ok, %{"enable" => true}} =
             ZeroTrustOrganization.update_doh_settings(client, "acc", %{
               "enable" => true
             })
  end

  test "revoke_user/4 posts body with query", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/access/organizations/revoke_user?devices=true"

      assert Jason.decode!(body) == %{"email" => "user@example.com"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustOrganization.revoke_user(
               client,
               "acc",
               %{"email" => "user@example.com"},
               devices: true
             )
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 33}]}}}
    end)

    assert {:error, [_]} = ZeroTrustOrganization.get(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
