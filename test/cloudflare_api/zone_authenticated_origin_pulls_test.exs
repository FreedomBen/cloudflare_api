defmodule CloudflareApi.ZoneAuthenticatedOriginPullsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAuthenticatedOriginPulls

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_certificates/3 applies query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/origin_tls_client_auth?per_page=50"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [%{"id" => "cert"}]} =
             ZoneAuthenticatedOriginPulls.list_certificates(client, "zone", per_page: 50)
  end

  test "certificate CRUD helpers cover upload/get/delete", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/origin_tls_client_auth"
        assert Jason.decode!(body) == %{"name" => "cert"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "cert"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/origin_tls_client_auth/cert"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cert"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/origin_tls_client_auth/cert"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "cert"}} =
             ZoneAuthenticatedOriginPulls.upload_certificate(client, "zone", %{"name" => "cert"})

    assert {:ok, %{"id" => "cert"}} =
             ZoneAuthenticatedOriginPulls.get_certificate(client, "zone", "cert")

    assert {:ok, %{}} = ZoneAuthenticatedOriginPulls.delete_certificate(client, "zone", "cert")
  end

  test "settings helpers get/put the settings endpoint", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/origin_tls_client_auth/settings"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/origin_tls_client_auth/settings"
        assert Jason.decode!(body) == %{"enabled" => false}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => false}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             ZoneAuthenticatedOriginPulls.get_settings(client, "zone")

    assert {:ok, %{"enabled" => false}} =
             ZoneAuthenticatedOriginPulls.update_settings(client, "zone", %{"enabled" => false})
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} =
             ZoneAuthenticatedOriginPulls.list_certificates(client, "zone")
  end
end
