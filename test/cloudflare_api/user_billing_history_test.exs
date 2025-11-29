defmodule CloudflareApi.UserBillingHistoryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UserBillingHistory

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches billing history", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/user/billing/history?per_page=5"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "invoice"}]}}}
    end)

    assert {:ok, [%{"id" => "invoice"}]} =
             UserBillingHistory.list(client, per_page: 5)
  end
end
