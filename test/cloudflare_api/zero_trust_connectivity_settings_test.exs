defmodule CloudflareApi.ZeroTrustConnectivitySettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustConnectivitySettings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 retrieves settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/zerotrust/connectivity_settings"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"split_tunnel" => "exclude"}}}}
    end)

    assert {:ok, %{"split_tunnel" => "exclude"}} =
             ZeroTrustConnectivitySettings.get(client, "acc")
  end

  test "patch/3 updates settings", %{client: client} do
    params = %{"split_tunnel" => "include"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) == "/accounts/acc/zerotrust/connectivity_settings"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustConnectivitySettings.patch(client, "acc", params)
  end

  test "handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 123}]}}}
    end)

    assert {:error, [_]} = ZeroTrustConnectivitySettings.get(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
