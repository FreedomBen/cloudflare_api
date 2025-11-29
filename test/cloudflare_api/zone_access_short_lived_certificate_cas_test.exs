defmodule CloudflareApi.ZoneAccessShortLivedCertificateCasTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessShortLivedCertificateCas

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits the aggregate CA endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/access/apps/ca"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"app_id" => "app"}]}}}
    end)

    assert {:ok, [%{"app_id" => "app"}]} = ZoneAccessShortLivedCertificateCas.list(client, "zone")
  end

  test "per-app helpers cover create/get/delete", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/ca"
        assert Jason.decode!(body) == %{"name" => "CA"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "CA"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/ca"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "CA"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/ca"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "CA"}} =
             ZoneAccessShortLivedCertificateCas.create(client, "zone", "app", %{"name" => "CA"})

    assert {:ok, %{"name" => "CA"}} =
             ZoneAccessShortLivedCertificateCas.get(client, "zone", "app")

    assert {:ok, %{}} = ZoneAccessShortLivedCertificateCas.delete(client, "zone", "app")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 321}]}}}
    end)

    assert {:error, [%{"code" => 321}]} =
             ZoneAccessShortLivedCertificateCas.create(client, "zone", "app", %{})
  end
end
