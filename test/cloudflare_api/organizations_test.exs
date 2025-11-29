defmodule CloudflareApi.OrganizationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Organizations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/organizations?id=foo"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "foo"}]}}}
    end)

    assert {:ok, [%{"id" => "foo"}]} = Organizations.list(client, id: "foo")
  end

  test "update_profile/4 PUTs JSON body", %{client: client} do
    params = %{"name" => "Org"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/organizations/org/profile"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Organizations.update_profile(client, "org", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = Organizations.delete(client, "org")
  end

  test "list_accounts/4 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} = Organizations.list_accounts(client, "org")
  end
end
