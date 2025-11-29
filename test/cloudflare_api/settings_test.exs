defmodule CloudflareApi.SettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Settings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches settings", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/cni/settings"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"mode" => "auto"}}}}
    end)

    assert {:ok, %{"mode" => "auto"}} = Settings.get(client, "acc")
  end

  test "update/3 posts JSON body", %{client: client} do
    params = %{"mode" => "manual"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Settings.update(client, "acc", params)
  end

  test "update/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} = Settings.update(client, "acc", %{})
  end
end
