defmodule CloudflareApi.MagicNetworkMonitoringConfigurationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicNetworkMonitoringConfiguration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches configuration", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/mnm/config"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "config"}}}}
    end)

    assert {:ok, %{"name" => "config"}} = MagicNetworkMonitoringConfiguration.get(client, "acc")
  end

  test "get_full/2 hits /full endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/mnm/config/full"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"rules" => []}}}}
    end)

    assert {:ok, %{"rules" => []}} = MagicNetworkMonitoringConfiguration.get_full(client, "acc")
  end

  test "create/3 posts params", %{client: client} do
    params = %{"name" => "cfg", "default_sampling" => 1}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = MagicNetworkMonitoringConfiguration.create(client, "acc", params)
  end

  test "update_fields/3 uses PATCH", %{client: client} do
    params = %{"default_sampling" => 2}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MagicNetworkMonitoringConfiguration.update_fields(client, "acc", params)
  end

  test "delete/2 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "cfg"}}}}
    end)

    assert {:ok, %{"name" => "cfg"}} = MagicNetworkMonitoringConfiguration.delete(client, "acc")
  end

  test "replace/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 7001}]}}}
    end)

    assert {:error, [%{"code" => 7001}]} =
             MagicNetworkMonitoringConfiguration.replace(client, "acc", %{
               "name" => "cfg",
               "default_sampling" => 1
             })
  end
end
