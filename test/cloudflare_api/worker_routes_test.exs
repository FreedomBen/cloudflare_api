defmodule CloudflareApi.WorkerRoutesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerRoutes

  setup do
    client = CloudflareApi.new("token")
    {:ok, client: client}
  end

  test "list/2 returns routes", %{client: client} do
    mock(fn %Tesla.Env{
              method: :get,
              url: "https://api.cloudflare.com/client/v4/zones/zone/workers/routes"
            } = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"pattern" => "*"}]}}}
    end)

    assert {:ok, [%{"pattern" => "*"}]} = WorkerRoutes.list(client, "zone")
  end

  test "create/3 sends params", %{client: client} do
    params = %{"pattern" => "*.example.com/*", "script" => "worker"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/workers/routes"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkerRoutes.create(client, "zone", params)
  end

  test "update/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{
              method: :put,
              url: "https://api.cloudflare.com/client/v4/zones/z/workers/routes/r"
            } = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 1001}]}
       }}
    end)

    assert {:error, [%{"code" => 1001}]} = WorkerRoutes.update(client, "z", "r", %{})
  end

  test "delete/3 sends empty body and returns result id", %{client: client} do
    mock(fn %Tesla.Env{
              method: :delete,
              body: body,
              url: "https://api.cloudflare.com/client/v4/zones/z/workers/routes/r"
            } = env ->
      assert body == "{}"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "r"}}}}
    end)

    assert {:ok, %{"id" => "r"}} = WorkerRoutes.delete(client, "z", "r")
  end
end
