defmodule CloudflareApi.GatewayCaTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.GatewayCa

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches certificate authorities", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/gateway_ca"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ca1"}]}}}
    end)

    assert {:ok, [%{"id" => "ca1"}]} = GatewayCa.list(client, "acc")
  end

  test "create/3 posts the provided params", %{client: client} do
    params = %{"public_key" => "ssh-ed25519 AAAAC3Nza..."}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/gateway_ca"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 201, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = GatewayCa.create(client, "acc", params)
  end

  test "delete/3 issues a DELETE without a body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/access/gateway_ca/ca1"
      assert body in [nil, ""]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ca1"}}}}
    end)

    assert {:ok, %{"id" => "ca1"}} = GatewayCa.delete(client, "acc", "ca1")
  end

  test "handle_response/1 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = GatewayCa.list(client, "acc")
  end
end
