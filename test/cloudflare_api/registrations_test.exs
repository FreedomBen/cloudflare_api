defmodule CloudflareApi.RegistrationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Registrations

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 fetches registrations", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices/registrations"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "reg"}]}}}
    end)

    assert {:ok, [%{"id" => "reg"}]} = Registrations.list(client, "acc")
  end

  test "revoke/3 posts params", %{client: client} do
    params = %{"registration_ids" => ["reg"]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/devices/registrations/revoke"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"revoked" => 1}}}}
    end)

    assert {:ok, %{"revoked" => 1}} = Registrations.revoke(client, "acc", params)
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = Registrations.delete(client, "acc", "reg")
  end

  test "get/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 6}]}}}
    end)

    assert {:error, [%{"code" => 6}]} = Registrations.get(client, "acc", "missing")
  end
end
