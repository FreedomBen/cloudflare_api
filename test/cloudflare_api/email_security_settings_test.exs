defmodule CloudflareApi.EmailSecuritySettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EmailSecuritySettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_allow_policies/3 fetches policies", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email-security/settings/allow_policies?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "pol"}]}}}
    end)

    assert {:ok, [_]} =
             EmailSecuritySettings.list_allow_policies(client, "acc", per_page: 5)
  end

  test "create_allow_policy/3 posts JSON", %{client: client} do
    params = %{"name" => "policy"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             EmailSecuritySettings.create_allow_policy(client, "acc", params)
  end

  test "update_blocked_sender/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 123}]}}}
    end)

    assert {:error, [%{"code" => 123}]} =
             EmailSecuritySettings.update_blocked_sender(client, "acc", "pattern", %{})
  end

  test "list_domains/3 hits domains endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email-security/settings/domains"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"domain" => "example"}]}}}
    end)

    assert {:ok, [_]} = EmailSecuritySettings.list_domains(client, "acc")
  end

  test "delete_domain/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             EmailSecuritySettings.delete_domain(client, "acc", "domain")
  end

  test "list_trusted_domains/3 fetches trusted domains", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email-security/settings/trusted_domains"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "trust"}]}}}
    end)

    assert {:ok, [_]} = EmailSecuritySettings.list_trusted_domains(client, "acc")
  end

  test "create_trusted_domain/3 posts JSON", %{client: client} do
    params = %{"domain" => "trusted.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             EmailSecuritySettings.create_trusted_domain(client, "acc", params)
  end
end
