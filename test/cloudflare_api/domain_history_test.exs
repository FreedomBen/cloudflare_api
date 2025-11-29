defmodule CloudflareApi.DomainHistoryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DomainHistory

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/domain-history?domain=example.com"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"domain" => "example.com"}]}}}
    end)

    assert {:ok, [_]} =
             DomainHistory.get(client, "acc", domain: "example.com")
  end

  test "get/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"message" => "not found"}]}}}
    end)

    assert {:error, [%{"message" => "not found"}]} =
             DomainHistory.get(client, "acc", domain: "missing")
  end
end
