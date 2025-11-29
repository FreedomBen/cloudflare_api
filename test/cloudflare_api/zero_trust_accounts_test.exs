defmodule CloudflareApi.ZeroTrustAccountsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustAccounts

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  describe "device settings" do
    test "get_device_settings/2 fetches settings", %{client: client} do
      mock(fn %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/accounts/acc/devices/settings"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"policy" => "allow"}}}}
      end)

      assert {:ok, %{"policy" => "allow"}} =
               ZeroTrustAccounts.get_device_settings(client, "acc")
    end

    test "delete_device_settings/2 issues DELETE body", %{client: client} do
      mock(fn %Tesla.Env{method: :delete, body: body} = env ->
        assert url(env) == "/accounts/acc/devices/settings"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} = ZeroTrustAccounts.delete_device_settings(client, "acc")
    end

    test "patch/update device settings send JSON", %{client: client} do
      params = %{"policy" => "deny"}

      mock(fn %Tesla.Env{method: :patch, body: body} = env ->
        assert url(env) == "/accounts/acc/devices/settings"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} =
               ZeroTrustAccounts.patch_device_settings(client, "acc", params)

      mock(fn %Tesla.Env{method: :put, body: body} = env ->
        assert url(env) == "/accounts/acc/devices/settings"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} =
               ZeroTrustAccounts.update_device_settings(client, "acc", params)
    end
  end

  describe "gateway account info" do
    test "get/create account", %{client: client} do
      mock(fn %Tesla.Env{method: :get} = env ->
        assert url(env) == "/accounts/acc/gateway"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"plan" => "pro"}}}}
      end)

      assert {:ok, %{"plan" => "pro"}} =
               ZeroTrustAccounts.get_account(client, "acc")

      mock(fn %Tesla.Env{method: :post, body: body} = env ->
        assert url(env) == "/accounts/acc/gateway"
        assert Jason.decode!(body) == %{"plan" => "enterprise"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"plan" => "enterprise"}}}}
      end)

      assert {:ok, %{"plan" => "enterprise"}} =
               ZeroTrustAccounts.create_account(client, "acc", %{"plan" => "enterprise"})
    end
  end

  describe "gateway configuration" do
    test "get/patch/put configuration", %{client: client} do
      mock(fn %Tesla.Env{method: :get} = env ->
        assert url(env) == "/accounts/acc/gateway/configuration"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"mode" => "custom"}}}}
      end)

      assert {:ok, %{"mode" => "custom"}} =
               ZeroTrustAccounts.get_configuration(client, "acc")

      params = %{"mode" => "default"}

      mock(fn %Tesla.Env{method: :patch, body: body} = env ->
        assert url(env) == "/accounts/acc/gateway/configuration"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} =
               ZeroTrustAccounts.patch_configuration(client, "acc", params)

      mock(fn %Tesla.Env{method: :put, body: body} = env ->
        assert url(env) == "/accounts/acc/gateway/configuration"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} =
               ZeroTrustAccounts.update_configuration(client, "acc", params)
    end

    test "custom certificate configuration", %{client: client} do
      mock(fn %Tesla.Env{method: :get} = env ->
        assert url(env) ==
                 "/accounts/acc/gateway/configuration/custom_certificate"

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} =
               ZeroTrustAccounts.get_custom_certificate_configuration(client, "acc")
    end
  end

  describe "logging settings" do
    test "get/update logging settings", %{client: client} do
      mock(fn %Tesla.Env{method: :get} = env ->
        assert url(env) == "/accounts/acc/gateway/logging"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
      end)

      assert {:ok, %{"enabled" => true}} =
               ZeroTrustAccounts.get_logging_settings(client, "acc")

      params = %{"enabled" => false}

      mock(fn %Tesla.Env{method: :put, body: body} = env ->
        assert url(env) == "/accounts/acc/gateway/logging"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} =
               ZeroTrustAccounts.update_logging_settings(client, "acc", params)
    end
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [_]} = ZeroTrustAccounts.get_account(client, "missing")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
