defmodule CloudflareApi.BotSettingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.BotSettings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches bot management config", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/bot_management"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"fight_mode" => true}}
       }}
    end)

    assert {:ok, %{"fight_mode" => true}} = BotSettings.get(client, "zone")
  end

  test "update/3 sends JSON body and surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/bot_management"
      assert Jason.decode!(body) == %{"fight_mode" => false}

      {:ok,
       %Tesla.Env{
         env
         | status: 422,
           body: %{"errors" => [%{"code" => 2005, "message" => "invalid"}]}
       }}
    end)

    assert {:error, [%{"code" => 2005, "message" => "invalid"}]} =
             BotSettings.update(client, "zone", %{"fight_mode" => false})
  end
end
