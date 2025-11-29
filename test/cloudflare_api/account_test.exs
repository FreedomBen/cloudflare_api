defmodule CloudflareApi.AccountTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Account

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "limits/2 hits account limits endpoint", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/accounts/acc/builds/account/limits"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"remaining" => 10}}}}
    end)

    assert {:ok, %{"remaining" => 10}} = Account.limits(client, "acc")
  end
end
