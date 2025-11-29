defmodule CloudflareApi.ZeroTrustSshSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustSshSettings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/audit_ssh_settings"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = ZeroTrustSshSettings.get(client, "acc")
  end

  test "update/3 sends JSON body", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/audit_ssh_settings"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustSshSettings.update(client, "acc", params)
  end

  test "rotate_seed/2 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/audit_ssh_settings/rotate_seed"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"seed" => "rotated"}}}}
    end)

    assert {:ok, %{"seed" => "rotated"}} =
             ZeroTrustSshSettings.rotate_seed(client, "acc")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 44}]}}}
    end)

    assert {:error, [_]} = ZeroTrustSshSettings.get(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
