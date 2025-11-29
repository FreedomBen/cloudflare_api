defmodule CloudflareApi.PerHostnameAuthenticatedOriginPullTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PerHostnameAuthenticatedOriginPull

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "set_hostnames/3 PUTs payload", %{client: client} do
    params = %{"hostnames" => [%{"hostname" => "a.com", "enabled" => true}]}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/origin_tls_client_auth/hostnames"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             PerHostnameAuthenticatedOriginPull.set_hostnames(client, "zone", params)
  end

  test "list_certificates/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/origin_tls_client_auth/hostnames/certificates?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [%{"id" => "cert"}]} =
             PerHostnameAuthenticatedOriginPull.list_certificates(client, "zone", page: 2)
  end

  test "delete_certificate/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             PerHostnameAuthenticatedOriginPull.delete_certificate(client, "zone", "cert")
  end

  test "get_certificate/3 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 44}]}}}
    end)

    assert {:error, [%{"code" => 44}]} =
             PerHostnameAuthenticatedOriginPull.get_certificate(client, "zone", "missing")
  end
end
