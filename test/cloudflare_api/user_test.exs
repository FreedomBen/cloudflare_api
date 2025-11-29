defmodule CloudflareApi.UserTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.User

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/1 returns user info", %{client: client} do
    mock(fn %Tesla.Env{url: "https://api.cloudflare.com/client/v4/user"} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"email" => "user@example"}}}}
    end)

    assert {:ok, %{"email" => "user@example"}} = User.get(client)
  end

  test "update/2 patches body", %{client: client} do
    params = %{"first_name" => "Pat"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = User.update(client, params)
  end

  test "list_tenants/2 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/users/tenants?page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "tenant"}]}}}
    end)

    assert {:ok, [%{"id" => "tenant"}]} = User.list_tenants(client, page: 2)
  end
end
