defmodule CloudflareApi.CloudflareTunnelConfigurationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudflareTunnelConfiguration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches configuration", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cfd_tunnel/tun/configurations"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ingress" => []}}}}
    end)

    assert {:ok, %{"ingress" => []}} =
             CloudflareTunnelConfiguration.get(client, "acc", "tun")
  end

  test "put/4 sends JSON payload", %{client: client} do
    params = %{"config" => %{"ingress" => [%{"hostname" => "app"}]}}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cfd_tunnel/tun/configurations"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CloudflareTunnelConfiguration.put(client, "acc", "tun", params)
  end
end
