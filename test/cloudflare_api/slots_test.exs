defmodule CloudflareApi.SlotsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Slots

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cni/slots?address_contains=Main&limit=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"slots" => []}}}}
    end)

    assert {:ok, %{"slots" => []}} =
             Slots.list(client, "acc", address_contains: "Main", limit: 5)
  end

  test "get/3 fetches a slot", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/cni/slots/slot-1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "slot-1"}}}}
    end)

    assert {:ok, %{"id" => "slot-1"}} = Slots.get(client, "acc", "slot-1")
  end

  test "list/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 500}]}}}
    end)

    assert {:error, [%{"code" => 500}]} = Slots.list(client, "acc")
  end
end
