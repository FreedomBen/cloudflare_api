defmodule CloudflareApi.UniversalSslSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UniversalSslSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches universal SSL settings", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = UniversalSslSettings.get(client, "zone")
  end

  test "update/3 patches payload", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = UniversalSslSettings.update(client, "zone", params)
  end
end
