defmodule CloudflareApi.ZeroTrustGatewayAppTypeMappingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustGatewayAppTypeMappings

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches mappings", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/app_types"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"type" => "http"}]}}}
    end)

    assert {:ok, [_]} = ZeroTrustGatewayAppTypeMappings.list(client, "acc")
  end

  test "handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:error, [_]} = ZeroTrustGatewayAppTypeMappings.list(client, "acc")
  end
end
