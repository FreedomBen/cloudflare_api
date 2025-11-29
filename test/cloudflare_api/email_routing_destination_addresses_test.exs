defmodule CloudflareApi.EmailRoutingDestinationAddressesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EmailRoutingDestinationAddresses

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches addresses", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email/routing/addresses"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "addr"}]}}}
    end)

    assert {:ok, [_]} = EmailRoutingDestinationAddresses.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"email" => "user@example.com"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "addr"}}}}
    end)

    assert {:ok, %{"id" => "addr"}} =
             EmailRoutingDestinationAddresses.create(client, "acc", params)
  end

  test "get/3 retrieves address", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email/routing/addresses/addr"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "addr"}}}}
    end)

    assert {:ok, %{"id" => "addr"}} =
             EmailRoutingDestinationAddresses.get(client, "acc", "addr")
  end

  test "delete/3 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             EmailRoutingDestinationAddresses.delete(client, "acc", "addr")
  end
end
