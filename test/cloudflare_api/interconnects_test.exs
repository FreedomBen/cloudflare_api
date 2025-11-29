defmodule CloudflareApi.InterconnectsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Interconnects

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits interconnect endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cni/interconnects"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Interconnects.list(client, "acc")
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"name" => "colo"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Interconnects.create(client, "acc", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "icon"}}}}
    end)

    assert {:ok, %{"id" => "icon"}} = Interconnects.delete(client, "acc", "icon")
  end

  test "get_loa/3 returns PDF body", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cni/interconnects/icon/loa"

      {:ok, %Tesla.Env{env | status: 200, body: "<<pdf>>"}}
    end)

    assert {:ok, "<<pdf>>"} = Interconnects.get_loa(client, "acc", "icon")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = Interconnects.list(client, "acc")
  end
end
