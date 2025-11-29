defmodule CloudflareApi.SinkholeConfigTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SinkholeConfig

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches sinkholes", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/intel/sinkholes"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"hostname" => "sink.example"}]}}}
    end)

    assert {:ok, [%{"hostname" => "sink.example"}]} = SinkholeConfig.list(client, "acc")
  end

  test "list/2 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 777}]}}}
    end)

    assert {:error, [%{"code" => 777}]} = SinkholeConfig.list(client, "acc")
  end
end
