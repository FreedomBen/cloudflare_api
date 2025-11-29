defmodule CloudflareApi.ZeroTrustHostnameRouteTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustHostnameRoute

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zerotrust/routes/hostname?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustHostnameRoute.list(client, "acc", page: 2)
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"hostname" => "example.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/zerotrust/routes/hostname"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustHostnameRoute.create(client, "acc", params)
  end

  test "delete/3 issues delete body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zerotrust/routes/hostname/route%2F1"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustHostnameRoute.delete(client, "acc", "route/1")
  end

  test "get/3 fetches route", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/zerotrust/routes/hostname/route%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "route/1"}}}}
    end)

    assert {:ok, %{"id" => "route/1"}} =
             ZeroTrustHostnameRoute.get(client, "acc", "route/1")
  end

  test "update/4 patches JSON", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/zerotrust/routes/hostname/route"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustHostnameRoute.update(client, "acc", "route", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 3}]}}}
    end)

    assert {:error, [_]} = ZeroTrustHostnameRoute.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
