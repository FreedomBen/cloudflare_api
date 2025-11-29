defmodule CloudflareApi.SecondaryDnsPeerTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecondaryDnsPeer

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 posts peer payload", %{client: client} do
    params = %{"name" => "peer"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsPeer.create(client, "acc", params)
  end

  test "update/4 uses PUT", %{client: client} do
    params = %{"name" => "peer2"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/secondary_dns/peers/peer"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsPeer.update(client, "acc", "peer", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = SecondaryDnsPeer.delete(client, "acc", "peer")
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 33}]}}}
    end)

    assert {:error, [%{"code" => 33}]} = SecondaryDnsPeer.get(client, "acc", "missing")
  end
end
