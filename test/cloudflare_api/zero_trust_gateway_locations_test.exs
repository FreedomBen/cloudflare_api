defmodule CloudflareApi.ZeroTrustGatewayLocationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustGatewayLocations

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/locations?page=2&per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZeroTrustGatewayLocations.list(client, "acc", page: 2, per_page: 10)
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"name" => "HQ"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/gateway/locations"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayLocations.create(client, "acc", params)
  end

  test "delete/3 issues DELETE with body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/locations/loc%2F1"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustGatewayLocations.delete(client, "acc", "loc/1")
  end

  test "get/3 fetches location", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/gateway/locations/loc%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "loc/1"}}}}
    end)

    assert {:ok, %{"id" => "loc/1"}} =
             ZeroTrustGatewayLocations.get(client, "acc", "loc/1")
  end

  test "update/4 sends JSON body", %{client: client} do
    params = %{"name" => "Branch"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/gateway/locations/location"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustGatewayLocations.update(client, "acc", "location", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [_]} =
             ZeroTrustGatewayLocations.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
