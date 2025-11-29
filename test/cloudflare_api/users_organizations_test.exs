defmodule CloudflareApi.UsersOrganizationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UsersOrganizations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches organizations", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "org"}]}}}
    end)

    assert {:ok, [%{"id" => "org"}]} = UsersOrganizations.list(client)
  end

  test "delete/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 700}]}}}
    end)

    assert {:error, [%{"code" => 700}]} = UsersOrganizations.delete(client, "org")
  end
end
