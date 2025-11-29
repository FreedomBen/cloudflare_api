defmodule CloudflareApi.UsersInvitesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UsersInvites

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 requests invites", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "inv"}]}}}
    end)

    assert {:ok, [%{"id" => "inv"}]} = UsersInvites.list(client)
  end

  test "respond/3 patches body", %{client: client} do
    params = %{"status" => "accepted"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = UsersInvites.respond(client, "inv", params)
  end
end
