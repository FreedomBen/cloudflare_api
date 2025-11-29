defmodule CloudflareApi.ZoneAccessIdentityProvidersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessIdentityProviders

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits the listing endpoint with query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/access/identity_providers?page=3"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "idp"}]}}}
    end)

    assert {:ok, [%{"id" => "idp"}]} = ZoneAccessIdentityProviders.list(client, "zone", page: 3)
  end

  test "CRUD helpers wrap the expected paths", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/identity_providers"
        assert Jason.decode!(body) == %{"name" => "GitHub"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "GitHub"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/identity_providers/idp"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "idp"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/identity_providers/idp"
        assert Jason.decode!(body) == %{"name" => "Updated"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "Updated"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/identity_providers/idp"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "GitHub"}} =
             ZoneAccessIdentityProviders.create(client, "zone", %{"name" => "GitHub"})

    assert {:ok, %{"id" => "idp"}} = ZoneAccessIdentityProviders.get(client, "zone", "idp")

    assert {:ok, %{"name" => "Updated"}} =
             ZoneAccessIdentityProviders.update(client, "zone", "idp", %{"name" => "Updated"})

    assert {:ok, %{}} = ZoneAccessIdentityProviders.delete(client, "zone", "idp")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9000}]}}}
    end)

    assert {:error, [%{"code" => 9000}]} =
             ZoneAccessIdentityProviders.create(client, "zone", %{"name" => "GitHub"})
  end
end
