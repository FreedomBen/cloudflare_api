defmodule CloudflareApi.ZoneAccessServiceTokensTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessServiceTokens

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 adds query params when provided", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/access/service_tokens?per_page=20"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "tok"}]}}}
    end)

    assert {:ok, [%{"id" => "tok"}]} =
             ZoneAccessServiceTokens.list(client, "zone", per_page: 20)
  end

  test "create/get/update/delete map to their endpoints", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/service_tokens"
        assert Jason.decode!(body) == %{"name" => "svc"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "svc"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/service_tokens/tok"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "tok"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/service_tokens/tok"
        assert Jason.decode!(body) == %{"name" => "new"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "new"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/service_tokens/tok"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "svc"}} =
             ZoneAccessServiceTokens.create(client, "zone", %{"name" => "svc"})

    assert {:ok, %{"id" => "tok"}} = ZoneAccessServiceTokens.get(client, "zone", "tok")

    assert {:ok, %{"name" => "new"}} =
             ZoneAccessServiceTokens.update(client, "zone", "tok", %{"name" => "new"})

    assert {:ok, %{}} = ZoneAccessServiceTokens.delete(client, "zone", "tok")
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 429, body: %{"errors" => [%{"code" => 1025}]}}}
    end)

    assert {:error, [%{"code" => 1025}]} =
             ZoneAccessServiceTokens.create(client, "zone", %{"name" => "svc"})
  end
end
