defmodule CloudflareApi.WorkersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Workers

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_builds_by_script/4 encodes path and query", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/builds/workers/script%2Fid/builds?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "build"}]}}}
    end)

    assert {:ok, [_]} = Workers.list_builds_by_script(client, "acc", "script/id", page: 2)
  end

  test "list_triggers_by_script/4 hits triggers endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/builds/workers/script%2Fid/triggers"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Workers.list_triggers_by_script(client, "acc", "script/id")
  end

  test "list_workers/3 handles pagination opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/workers?per_page=10"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "svc"}]}}}
    end)

    assert {:ok, [_]} = Workers.list_workers(client, "acc", per_page: 10)
  end

  test "create_worker/3 posts JSON", %{client: client} do
    params = %{"name" => "svc"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Workers.create_worker(client, "acc", params)
  end

  test "delete_worker/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workers/workers/svc"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = Workers.delete_worker(client, "acc", "svc")
  end

  test "get_worker/3 fetches a service", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/workers/svc"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "svc"}}}}
    end)

    assert {:ok, %{"id" => "svc"}} = Workers.get_worker(client, "acc", "svc")
  end

  test "patch_worker/4 sends JSON", %{client: client} do
    params = %{"description" => "demo"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Workers.patch_worker(client, "acc", "svc", params)
  end

  test "update_worker/4 sends JSON", %{client: client} do
    params = %{"name" => "svc"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Workers.update_worker(client, "acc", "svc", params)
  end

  test "bubbles API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 100}]}}}
    end)

    assert {:error, [_]} = Workers.list_workers(client, "acc")
  end
end
