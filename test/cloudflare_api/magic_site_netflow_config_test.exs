defmodule CloudflareApi.MagicSiteNetflowConfigTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicSiteNetflowConfig

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches config", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/magic/sites/site/netflow_config"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"state" => "on"}}}}
    end)

    assert {:ok, %{"state" => "on"}} = MagicSiteNetflowConfig.get(client, "acc", "site")
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"state" => "off"}}}}
    end)

    assert {:ok, %{"state" => "off"}} = MagicSiteNetflowConfig.delete(client, "acc", "site")
  end
end
