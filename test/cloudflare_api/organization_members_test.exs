defmodule CloudflareApi.OrganizationMembersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.OrganizationMembers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/organizations/org%2F1/members?role=admin"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "mem"}]}}}
    end)

    assert {:ok, [%{"id" => "mem"}]} = OrganizationMembers.list(client, "org/1", role: "admin")
  end

  test "batch_create/3 posts JSON body", %{client: client} do
    params = %{"members" => [%{"email" => "user@example.com"}]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/organizations/org/members:batchCreate"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = OrganizationMembers.batch_create(client, "org", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "mem"}}}}
    end)

    assert {:ok, %{"id" => "mem"}} = OrganizationMembers.delete(client, "org", "mem")
  end

  test "get/3 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 4040}]}}}
    end)

    assert {:error, [%{"code" => 4040}]} = OrganizationMembers.get(client, "org", "missing")
  end
end
