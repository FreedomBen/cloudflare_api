defmodule CloudflareApi.AccountsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Accounts

  test "list/2 passes query params" do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts?name=example"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"name" => "Example"}]}
       }}
    end)

    client = CloudflareApi.new("token")
    assert {:ok, [%{"name" => "Example"}]} = Accounts.list(client, name: "example")
  end

  test "get/2 normalises errors" do
    mock(fn %Tesla.Env{method: :get, url: "https://api.cloudflare.com/client/v4/accounts/acc"} =
              env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 1000}]}
       }}
    end)

    client = CloudflareApi.new("token")
    assert {:error, [%{"code" => 1000}]} = Accounts.get(client, "acc")
  end
end
