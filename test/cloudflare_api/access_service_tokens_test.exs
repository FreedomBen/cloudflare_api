defmodule CloudflareApi.AccessServiceTokensTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccessServiceTokens

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/service_tokens?per_page=6"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "token"}]}}}
    end)

    assert {:ok, [_]} = AccessServiceTokens.list(client, "acc", per_page: 6)
  end

  test "rotate/4 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/service_tokens/token/rotate"

      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"rotated" => true}}}}
    end)

    assert {:ok, %{"rotated" => true}} = AccessServiceTokens.rotate(client, "acc", "token")
  end
end
