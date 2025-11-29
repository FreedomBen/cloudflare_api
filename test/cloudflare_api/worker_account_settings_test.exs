defmodule CloudflareApi.WorkerAccountSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerAccountSettings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_settings/2 fetches the account settings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/account-settings"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"type" => "standard"}}}}
    end)

    assert {:ok, %{"type" => "standard"}} =
             WorkerAccountSettings.get_settings(client, "acc")
  end

  test "update_settings/3 sends JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workers/account-settings"
      assert Jason.decode!(body) == %{"default_usage_model" => "unbound"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             WorkerAccountSettings.update_settings(client, "acc", %{
               "default_usage_model" => "unbound"
             })
  end

  test "returns errors from API", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:error, [%{"code" => 42}]} =
             WorkerAccountSettings.update_settings(client, "acc", %{})
  end
end
