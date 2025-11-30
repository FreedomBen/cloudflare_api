defmodule CloudflareApi.ZoneZeroTrustOrganizationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneZeroTrustOrganization

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "CRUD helpers map to zone-level organization endpoints", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/organizations"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "org"}}}}

      %Tesla.Env{method: :post, url: url, body: body} = env ->
        if String.ends_with?(url, "/revoke_user") do
          assert Jason.decode!(body) == %{"email" => "user@example.com"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
        else
          assert Jason.decode!(body) == %{"name" => "org"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "org"}}}}
        end

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/organizations"
        assert Jason.decode!(body) == %{"name" => "new"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "new"}}}}
    end)

    assert {:ok, %{"name" => "org"}} = ZoneZeroTrustOrganization.get(client, "zone")

    assert {:ok, %{"name" => "org"}} =
             ZoneZeroTrustOrganization.create(client, "zone", %{"name" => "org"})

    assert {:ok, %{"name" => "new"}} =
             ZoneZeroTrustOrganization.update(client, "zone", %{"name" => "new"})

    assert {:ok, %{}} =
             ZoneZeroTrustOrganization.revoke_user(client, "zone", %{
               "email" => "user@example.com"
             })
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             ZoneZeroTrustOrganization.create(client, "zone", %{"name" => "org"})
  end
end
