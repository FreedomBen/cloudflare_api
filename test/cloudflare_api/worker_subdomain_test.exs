defmodule CloudflareApi.WorkerSubdomainTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerSubdomain

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches subdomain", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/subdomain"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"subdomain" => "foo"}}}}
    end)

    assert {:ok, %{"subdomain" => "foo"}} = WorkerSubdomain.get(client, "acc")
  end

  test "create/3 sends JSON body", %{client: client} do
    params = %{"subdomain" => "foo"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkerSubdomain.create(client, "acc", params)
  end

  test "delete/2 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = WorkerSubdomain.delete(client, "acc")
  end

  test "error passthrough", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 7}]}}}
    end)

    assert {:error, [_]} = WorkerSubdomain.get(client, "acc")
  end
end
