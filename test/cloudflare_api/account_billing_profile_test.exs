defmodule CloudflareApi.AccountBillingProfileTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountBillingProfile

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 hits billing profile endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/billing/profile"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "acct"}}}}
    end)

    assert {:ok, %{"name" => "acct"}} = AccountBillingProfile.get(client, "acc")
  end
end
