defmodule CloudflareApi.ZoneAccessMtlsAuthenticationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessMtlsAuthentication

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_certificates/3 sends optional pagination", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/access/certificates?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [%{"id" => "cert"}]} =
             ZoneAccessMtlsAuthentication.list_certificates(client, "zone", page: 1)
  end

  test "certificate CRUD helpers map to expected routes", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/certificates"
        assert Jason.decode!(body) == %{"name" => "My Cert"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "My Cert"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/certificates/cert"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cert"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/certificates/cert"
        assert Jason.decode!(body) == %{"name" => "Renamed"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "Renamed"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/certificates/cert"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "My Cert"}} =
             ZoneAccessMtlsAuthentication.create_certificate(client, "zone", %{
               "name" => "My Cert"
             })

    assert {:ok, %{"id" => "cert"}} =
             ZoneAccessMtlsAuthentication.get_certificate(client, "zone", "cert")

    assert {:ok, %{"name" => "Renamed"}} =
             ZoneAccessMtlsAuthentication.update_certificate(client, "zone", "cert", %{
               "name" => "Renamed"
             })

    assert {:ok, %{}} = ZoneAccessMtlsAuthentication.delete_certificate(client, "zone", "cert")
  end

  test "settings helpers GET/PUT the settings endpoint", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/certificates/settings"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"hostname_settings" => []}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/certificates/settings"
        assert Jason.decode!(body) == %{"hostname_settings" => []}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"hostname_settings" => []}}}}
    end)

    assert {:ok, %{"hostname_settings" => []}} =
             ZoneAccessMtlsAuthentication.get_settings(client, "zone")

    assert {:ok, %{"hostname_settings" => []}} =
             ZoneAccessMtlsAuthentication.update_settings(
               client,
               "zone",
               %{"hostname_settings" => []}
             )
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} =
             ZoneAccessMtlsAuthentication.list_certificates(client, "zone")
  end
end
