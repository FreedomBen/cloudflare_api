defmodule CloudflareApi.ApiShieldSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ApiShieldSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_configuration/2 hits configuration endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/zones/zone/api_gateway/configuration"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"setting" => true}}}}
    end)

    assert {:ok, %{"setting" => true}} = ApiShieldSettings.get_configuration(client, "zone")
  end

  test "update_configuration/3 sends JSON body", %{client: client} do
    params = %{"setting" => false}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ApiShieldSettings.update_configuration(client, "zone", params)
  end
end
