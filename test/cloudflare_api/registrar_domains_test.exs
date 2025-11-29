defmodule CloudflareApi.RegistrarDomainsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RegistrarDomains

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/registrar/domains?status=active"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "example.com"}]}}}
    end)

    assert {:ok, [%{"name" => "example.com"}]} = RegistrarDomains.list(client, "acc", status: "active")
  end

  test "update/4 PUTs payload", %{client: client} do
    params = %{"locked" => true}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = RegistrarDomains.update(client, "acc", "example.com", params)
  end

  test "get/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [%{"code" => 10}]} = RegistrarDomains.get(client, "acc", "missing.com")
  end
end
