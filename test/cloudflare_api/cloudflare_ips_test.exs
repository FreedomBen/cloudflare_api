defmodule CloudflareApi.CloudflareIpsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudflareIps

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 forwards query opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/ips?networks=jdcloud"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"ipv4_cidrs" => []}
       }}
    end)

    assert {:ok, %{"ipv4_cidrs" => []}} =
             CloudflareIps.list(client, networks: "jdcloud")
  end

  test "list/2 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 500,
           body: %{"errors" => [%{"code" => 1}]}
       }}
    end)

    assert {:error, [%{"code" => 1}]} = CloudflareIps.list(client)
  end
end
