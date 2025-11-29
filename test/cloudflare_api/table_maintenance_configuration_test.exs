defmodule CloudflareApi.TableMaintenanceConfigurationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TableMaintenanceConfiguration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/6 hits maintenance path with query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/r2-catalog/bkt/namespaces/ns/tables/tbl/maintenance-configs?expand=true"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             TableMaintenanceConfiguration.get(client, "acc", "bkt", "ns", "tbl", expand: true)
  end

  test "update/6 posts payload", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             TableMaintenanceConfiguration.update(client, "acc", "bkt", "ns", "tbl", params)
  end
end
