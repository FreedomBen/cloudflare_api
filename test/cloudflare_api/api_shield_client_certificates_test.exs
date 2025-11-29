defmodule CloudflareApi.ApiShieldClientCertificatesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ApiShieldClientCertificates

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_certificates/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/client_certificates?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [_]} =
             ApiShieldClientCertificates.list_certificates(client, "zone", per_page: 5)
  end

  test "update_hostname_associations/3 sends JSON", %{client: client} do
    params = %{"hostnames" => ["api.example.com"]}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/certificate_authorities/hostname_associations"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ApiShieldClientCertificates.update_hostname_associations(client, "zone", params)
  end
end
