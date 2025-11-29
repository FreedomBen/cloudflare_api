defmodule CloudflareApi.CloudflareTunnelsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudflareTunnels

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_cfd/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cfd_tunnel?status=active&name=blog"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"name" => "blog"}]}
       }}
    end)

    assert {:ok, [_]} =
             CloudflareTunnels.list_cfd(client, "acc", status: "active", name: "blog")
  end

  test "create_cfd/3 sends JSON payload", %{client: client} do
    params = %{"name" => "app"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/cfd_tunnel"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CloudflareTunnels.create_cfd(client, "acc", params)
  end

  test "token/3 fetches tunnel token", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cfd_tunnel/tun/token"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"token" => "abc"}}}}
    end)

    assert {:ok, %{"token" => "abc"}} = CloudflareTunnels.token(client, "acc", "tun")
  end

  test "cleanup_connections/4 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cfd_tunnel/tun/connections?client_id=abc"

      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 1000, "message" => "bad"}]}
       }}
    end)

    assert {:error, [%{"code" => 1000, "message" => "bad"}]} =
             CloudflareTunnels.cleanup_connections(client, "acc", "tun", client_id: "abc")
  end
end
