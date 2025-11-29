defmodule CloudflareApi.MagicNetworkMonitoringVpcFlowsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MagicNetworkMonitoringVpcFlows

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "generate_token/2 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/mnm/vpc-flows/token"
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"token" => "secret"}}}}
    end)

    assert {:ok, %{"token" => "secret"}} =
             MagicNetworkMonitoringVpcFlows.generate_token(client, "acc")
  end

  test "generate_token/2 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 401, body: %{"errors" => [%{"code" => 9000}]}}}
    end)

    assert {:error, [%{"code" => 9000}]} =
             MagicNetworkMonitoringVpcFlows.generate_token(client, "acc")
  end
end
