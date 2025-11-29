defmodule CloudflareApi.MtlsCertificateManagementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.MtlsCertificateManagement

  @base "https://api.cloudflare.com/client/v4/accounts/acct/mtls_certificates"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "certificate endpoints map correctly", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      case String.replace_prefix(env.url, @base, "") do
        "?page=1" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "" when env.method == :post ->
          assert Jason.decode!(env.body) == %{"name" => "cert"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cert"}}}}

        "/cert" when env.method == :get ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cert"}}}}

        "/cert" when env.method == :delete ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/cert/associations" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
      end
    end)

    assert {:ok, []} = MtlsCertificateManagement.list_certificates(client, "acct", page: 1)

    assert {:ok, %{"id" => "cert"}} =
             MtlsCertificateManagement.upload_certificate(client, "acct", %{"name" => "cert"})

    assert {:ok, %{"id" => "cert"}} =
             MtlsCertificateManagement.get_certificate(client, "acct", "cert")

    assert {:ok, %{}} = MtlsCertificateManagement.delete_certificate(client, "acct", "cert")

    assert {:ok, []} =
             MtlsCertificateManagement.list_associations(client, "acct", "cert")
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} =
             MtlsCertificateManagement.list_certificates(client, "acct")
  end
end
