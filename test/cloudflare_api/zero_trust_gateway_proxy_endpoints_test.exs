defmodule CloudflareApi.ZeroTrustGatewayProxyEndpointsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustGatewayProxyEndpoints

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/proxy_endpoints"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ep"}]}}}
    end)

    assert {:ok, [_]} = ZeroTrustGatewayProxyEndpoints.list(client, "acc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "endpoint"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/proxy_endpoints"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayProxyEndpoints.create(client, "acc", params)
  end

  test "delete/3 issues delete body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/proxy_endpoints/ep%2F1"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustGatewayProxyEndpoints.delete(client, "acc", "ep/1")
  end

  test "get/3 fetches endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/proxy_endpoints/ep%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ep/1"}}}}
    end)

    assert {:ok, %{"id" => "ep/1"}} =
             ZeroTrustGatewayProxyEndpoints.get(client, "acc", "ep/1")
  end

  test "update/4 patches JSON", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/gateway/proxy_endpoints/ep"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayProxyEndpoints.update(client, "acc", "ep", params)
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [_]} = ZeroTrustGatewayProxyEndpoints.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
