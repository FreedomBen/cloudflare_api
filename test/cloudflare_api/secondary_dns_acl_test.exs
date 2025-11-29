defmodule CloudflareApi.SecondaryDnsAclTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SecondaryDnsAcl

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits ACL endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/secondary_dns/acls"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "acl"}]}}}
    end)

    assert {:ok, [%{"id" => "acl"}]} = SecondaryDnsAcl.list(client, "acc")
  end

  test "create/3 posts params", %{client: client} do
    params = %{"name" => "acl", "ips" => ["1.1.1.1"]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SecondaryDnsAcl.create(client, "acc", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = SecondaryDnsAcl.delete(client, "acc", "acl")
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 22}]}}}
    end)

    assert {:error, [%{"code" => 22}]} = SecondaryDnsAcl.get(client, "acc", "missing")
  end
end
