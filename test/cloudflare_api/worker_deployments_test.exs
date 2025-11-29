defmodule CloudflareApi.WorkerDeploymentsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerDeployments

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits the deployments endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/deployments"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "dep"}]}}}
    end)

    assert {:ok, [%{"id" => "dep"}]} = WorkerDeployments.list(client, "acc", "script")
  end

  test "create/5 encodes optional query params", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/workers/scripts/script/deployments?force=true"

      assert Jason.decode!(body) == %{"strategy" => "all"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "dep"}}}}
    end)

    assert {:ok, %{"id" => "dep"}} =
             WorkerDeployments.create(client, "acc", "script", %{"strategy" => "all"},
               force: true
             )
  end

  test "get/4 fetches a deployment", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/deployments/dep"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "dep"}}}}
    end)

    assert {:ok, %{"id" => "dep"}} =
             WorkerDeployments.get(client, "acc", "script", "dep")
  end

  test "delete/4 sends the correct path", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/deployments/dep"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "dep"}}}}
    end)

    assert {:ok, %{"id" => "dep"}} =
             WorkerDeployments.delete(client, "acc", "script", "dep")
  end

  test "returns deployment errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} =
             WorkerDeployments.create(client, "acc", "script", %{}, force: true)
  end
end
