defmodule CloudflareApi.WorkflowsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Workflows

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workflows?page=2&search=sync"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Workflows.list(client, "acc", page: 2, search: "sync")
  end

  test "create_or_update/4 posts workflow definition", %{client: client} do
    params = %{"description" => "workflow"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/accounts/acc/workflows/my%2Fworkflow"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Workflows.create_or_update(client, "acc", "my/workflow", params)
  end

  test "get/delete workflow", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/accounts/acc/workflows/test"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "test"}}}}
    end)

    assert {:ok, %{"name" => "test"}} = Workflows.get(client, "acc", "test")

    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert url(env) == "/accounts/acc/workflows/test"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = Workflows.delete(client, "acc", "test")
  end

  test "versions endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/accounts/acc/workflows/test/versions?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Workflows.list_versions(client, "acc", "test", page: 1)

    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/accounts/acc/workflows/test/versions/v1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "v1"}}}}
    end)

    assert {:ok, %{"id" => "v1"}} =
             Workflows.get_version(client, "acc", "test", "v1")
  end

  test "list/create instances", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) ==
               "/accounts/acc/workflows/test/instances?status=running&cursor=abc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             Workflows.list_instances(client, "acc", "test",
               status: "running",
               cursor: "abc"
             )

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/workflows/test/instances"
      assert Jason.decode!(body) == %{"input" => %{}}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"instance_id" => "123"}}}}
    end)

    assert {:ok, %{"instance_id" => "123"}} =
             Workflows.create_instance(client, "acc", "test", %{"input" => %{}})
  end

  test "batch instance controls", %{client: client} do
    params = %{"instances" => [%{"input" => %{}}]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workflows/test/instances/batch"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             Workflows.batch_create_instances(client, "acc", "test", params)

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workflows/test/instances/batch/terminate"

      assert Jason.decode!(body) == %{"instance_ids" => ["1"]}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             Workflows.batch_terminate_instances(client, "acc", "test", %{
               "instance_ids" => ["1"]
             })

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workflows/test/instances/terminate"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "done"}}}}
    end)

    assert {:ok, %{"status" => "done"}} =
             Workflows.batch_termination_status(client, "acc", "test")
  end

  test "instance detail and status changes", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workflows/test/instances/inst"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "inst"}}}}
    end)

    assert {:ok, %{"id" => "inst"}} =
             Workflows.get_instance(client, "acc", "test", "inst")

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/workflows/test/instances/inst/events/trigger"

      assert Jason.decode!(body) == %{"data" => %{}}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             Workflows.send_event(client, "acc", "test", "inst", "trigger", %{
               "data" => %{}
             })

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/workflows/test/instances/inst/status"

      assert Jason.decode!(body) == %{"status" => "terminated"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             Workflows.change_status(client, "acc", "test", "inst", %{"status" => "terminated"})
  end

  test "propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 100}]}}}
    end)

    assert {:error, [_]} = Workflows.get(client, "acc", "missing")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
