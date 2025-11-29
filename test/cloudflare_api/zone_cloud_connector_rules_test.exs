defmodule CloudflareApi.ZoneCloudConnectorRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneCloudConnectorRules

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches rules", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/cloud_connector/rules"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = ZoneCloudConnectorRules.get(client, "zone")
  end

  test "put/3 updates rules", %{client: client} do
    params = %{"rules" => []}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/zones/zone/cloud_connector/rules"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ZoneCloudConnectorRules.put(client, "zone", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [_]} = ZoneCloudConnectorRules.get(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
