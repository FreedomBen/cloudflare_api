defmodule CloudflareApi.AccountSubscriptionsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AccountSubscriptions

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/subscriptions?per_page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "sub"}]}}}
    end)

    assert {:ok, [_]} = AccountSubscriptions.list(client, "acc", per_page: 1)
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             AccountSubscriptions.delete(client, "acc", "sub")
  end
end
