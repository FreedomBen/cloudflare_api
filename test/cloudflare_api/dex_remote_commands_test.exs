defmodule CloudflareApi.DexRemoteCommandsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DexRemoteCommands

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/commands?per_page=2&status=failed"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cmd"}]}}}
    end)

    assert {:ok, [%{"id" => "cmd"}]} =
             DexRemoteCommands.list(client, "acc", per_page: 2, status: "failed")
  end

  test "create/3 posts JSON params", %{client: client} do
    params = %{"type" => "capture", "device_id" => "dev"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/dex/commands"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cmd"}}}}
    end)

    assert {:ok, %{"id" => "cmd"}} = DexRemoteCommands.create(client, "acc", params)
  end

  test "eligible_devices/3 forwards opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/commands/devices?search=bob"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "dev"}]}}}
    end)

    assert {:ok, [%{"id" => "dev"}]} =
             DexRemoteCommands.eligible_devices(client, "acc", search: "bob")
  end

  test "quota/2 hits quota endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/dex/commands/quota"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"limit" => 10}}}}
    end)

    assert {:ok, %{"limit" => 10}} = DexRemoteCommands.quota(client, "acc")
  end

  test "download_output/4 returns binary body", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/commands/cmd/downloads/logs.zip"

      {:ok, %Tesla.Env{env | status: 200, body: <<0, 1, 2>>}}
    end)

    assert {:ok, <<0, 1, 2>>} =
             DexRemoteCommands.download_output(client, "acc", "cmd", "logs.zip")
  end

  test "create/3 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "oops"}]}}}
    end)

    assert {:error, [%{"message" => "oops"}]} =
             DexRemoteCommands.create(client, "acc", %{"type" => "capture"})
  end
end
