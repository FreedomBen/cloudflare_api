defmodule CloudflareApi.MaintenanceConfigurationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MaintenanceConfiguration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches maintenance config", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/r2-catalog/bucket/maintenance-configs"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             MaintenanceConfiguration.get(client, "acc", "bucket")
  end

  test "update/4 posts payload", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             MaintenanceConfiguration.update(client, "acc", "bucket", params)
  end

  test "update/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:error, [%{"code" => 42}]} =
             MaintenanceConfiguration.update(client, "acc", "bucket", %{})
  end
end
