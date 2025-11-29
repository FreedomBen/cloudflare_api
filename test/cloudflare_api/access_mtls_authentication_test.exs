defmodule CloudflareApi.AccessMtlsAuthenticationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessMtlsAuthentication

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_certificates/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/certificates?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [_]} = AccessMtlsAuthentication.list_certificates(client, "acc", per_page: 5)
  end

  test "create_certificate/3 sends JSON", %{client: client} do
    params = %{"certificate" => "..."}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessMtlsAuthentication.create_certificate(client, "acc", params)
  end

  test "update_settings/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{
              method: :put,
              url:
                "https://api.cloudflare.com/client/v4/accounts/acc/access/certificates/settings"
            } = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 321}]}}}
    end)

    assert {:error, [%{"code" => 321}]} =
             AccessMtlsAuthentication.update_settings(client, "acc", %{})
  end
end
