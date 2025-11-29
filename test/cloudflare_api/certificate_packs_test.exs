defmodule CloudflareApi.CertificatePacksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CertificatePacks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 adds optional status filter", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/ssl/certificate_packs?status=all"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "pack"}]}
       }}
    end)

    assert {:ok, [_]} = CertificatePacks.list(client, "zone", status: "all")
  end

  test "order/3 posts JSON payload", %{client: client} do
    params = %{"type" => "advanced", "hosts" => ["example.com"], "validation_method" => "txt"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/ssl/certificate_packs/order"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CertificatePacks.order(client, "zone", params)
  end

  test "restart_validation/4 PATCHes pack", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/ssl/certificate_packs/pack"

      {:ok,
       %Tesla.Env{
         env
         | status: 422,
           body: %{"errors" => [%{"code" => 2100, "message" => "cannot restart"}]}
       }}
    end)

    assert {:error, [%{"code" => 2100, "message" => "cannot restart"}]} =
             CertificatePacks.restart_validation(client, "zone", "pack", %{})
  end
end
