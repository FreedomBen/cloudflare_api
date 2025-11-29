defmodule CloudflareApi.UserAccountMembershipsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UserAccountMemberships

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 encodes params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/memberships?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "m"}]}}}
    end)

    assert {:ok, [%{"id" => "m"}]} = UserAccountMemberships.list(client, page: 1)
  end

  test "update/3 puts payload", %{client: client} do
    params = %{"status" => "accepted"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = UserAccountMemberships.update(client, "m", params)
  end

  test "delete/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 880}]}}}
    end)

    assert {:error, [%{"code" => 880}]} = UserAccountMemberships.delete(client, "m")
  end
end
