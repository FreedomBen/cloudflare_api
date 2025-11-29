defmodule CloudflareApi.AccountOwnedApiTokensTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountOwnedApiTokens

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/tokens?per_page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "token"}]}}}
    end)

    assert {:ok, [_]} = AccountOwnedApiTokens.list(client, "acc", per_page: 2)
  end

  test "roll/4 posts params", %{client: client} do
    params = %{"value" => "new"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/tokens/token/value"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = AccountOwnedApiTokens.roll(client, "acc", "token", params)
  end

  test "permission_groups/2 hits endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/tokens/permission_groups"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = AccountOwnedApiTokens.permission_groups(client, "acc")
  end
end
