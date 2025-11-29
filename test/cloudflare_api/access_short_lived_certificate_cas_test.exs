defmodule CloudflareApi.AccessShortLivedCertificateCasTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessShortLivedCertificateCas

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits CA list endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/access/apps/ca"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"app_id" => "app"}]}}}
    end)

    assert {:ok, [_]} = AccessShortLivedCertificateCas.list(client, "acc")
  end

  test "create/4 sends JSON body", %{client: client} do
    params = %{"name" => "ca"}

    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/apps/app/ca"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccessShortLivedCertificateCas.create(client, "acc", "app", params)
  end
end
