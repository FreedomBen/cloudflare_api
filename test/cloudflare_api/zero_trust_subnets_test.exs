defmodule CloudflareApi.ZeroTrustSubnetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustSubnets

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zerotrust/subnets?name=corp&per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustSubnets.list(client, "acc", name: "corp", per_page: 5)
  end

  test "update_cloudflare_source/4 sends JSON", %{client: client} do
    params = %{"network" => "192.0.2.0/24"}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zerotrust/subnets/cloudflare_source/ipv4"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustSubnets.update_cloudflare_source(
               client,
               "acc",
               "ipv4",
               params
             )
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 4}]}}}
    end)

    assert {:error, [_]} = ZeroTrustSubnets.list(client, "acc")
  end
end
