defmodule CloudflareApi.HyperdriveTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Hyperdrive

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits the configs path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/hyperdrive/configs"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Hyperdrive.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "db"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Hyperdrive.create(client, "acc", params)
  end

  test "patch/4 updates partial config", %{client: client} do
    params = %{"max_connections" => 5}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/hyperdrive/configs/conf"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Hyperdrive.patch(client, "acc", "conf", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "conf"}}}}
    end)

    assert {:ok, %{"id" => "conf"}} = Hyperdrive.delete(client, "acc", "conf")
  end

  test "handle_response/1 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = Hyperdrive.list(client, "acc")
  end
end
