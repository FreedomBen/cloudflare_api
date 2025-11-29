defmodule CloudflareApi.WorkersPipelinesOtherTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersPipelinesOther

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_deprecated/3 encodes opts", %{client: client} do
    body = %{"results" => [%{"name" => "pipe"}], "result_info" => %{}, "success" => true}

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/pipelines?page=2&search=foo"
      {:ok, %Tesla.Env{env | status: 200, body: body}}
    end)

    assert {:ok, ^body} =
             WorkersPipelinesOther.list_deprecated(client, "acc", page: 2, search: "foo")
  end

  test "create_deprecated/3 posts JSON", %{client: client} do
    payload = %{"name" => "pipe", "source" => [%{"type" => "http"}]}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/pipelines"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = WorkersPipelinesOther.create_deprecated(client, "acc", payload)
  end

  test "get/replace/delete deprecated paths encode names", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get} = env ->
        assert url(env) == "/accounts/acc/pipelines/my%20pipe"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "my pipe"}}}}

      %Tesla.Env{method: :put, body: body} = env ->
        assert url(env) == "/accounts/acc/pipelines/my%20pipe"
        assert Jason.decode!(body) == %{"name" => "my pipe"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "my pipe"}}}}

      %Tesla.Env{method: :delete} = env ->
        assert url(env) == "/accounts/acc/pipelines/my%20pipe"
        {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
    end)

    assert {:ok, %{"name" => "my pipe"}} =
             WorkersPipelinesOther.get_deprecated(client, "acc", "my pipe")

    assert {:ok, %{"name" => "my pipe"}} =
             WorkersPipelinesOther.replace_deprecated(client, "acc", "my pipe", %{
               "name" => "my pipe"
             })

    assert {:ok, %{"success" => true}} =
             WorkersPipelinesOther.delete_deprecated(client, "acc", "my pipe")
  end

  test "list/create/get/delete v1 pipelines", %{client: client} do
    payload = %{"name" => "v1-pipe"}

    mock(fn %Tesla.Env{} = env ->
      cond do
        env.method == :get && String.contains?(env.url, "/pipelines/v1/pipelines?") ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "1"}]}}}

        env.method == :post ->
          assert url(env) == "/accounts/acc/pipelines/v1/pipelines"
          assert Jason.decode!(env.body) == payload
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}

        env.method == :get ->
          assert env.url == @base <> "/accounts/acc/pipelines/v1/pipelines/pip%2F1"
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pip/1"}}}}

        env.method == :delete ->
          assert url(env) == "/accounts/acc/pipelines/v1/pipelines/pip%2F1"
          {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
      end
    end)

    assert {:ok, [%{"id" => "1"}]} =
             WorkersPipelinesOther.list_pipelines(client, "acc", page: 1)

    assert {:ok, ^payload} = WorkersPipelinesOther.create_pipeline(client, "acc", payload)
    assert {:ok, %{"id" => "pip/1"}} = WorkersPipelinesOther.get_pipeline(client, "acc", "pip/1")

    assert {:ok, %{"success" => true}} =
             WorkersPipelinesOther.delete_pipeline(client, "acc", "pip/1")
  end

  test "sink helpers cover CRUD", %{client: client} do
    payload = %{"name" => "sink"}

    mock(fn %Tesla.Env{} = env ->
      cond do
        env.method == :get && String.contains?(env.url, "/sinks?") ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "sink"}]}}}

        env.method == :post ->
          assert url(env) == "/accounts/acc/pipelines/v1/sinks"
          assert Jason.decode!(env.body) == payload
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}

        env.method == :get ->
          assert url(env) == "/accounts/acc/pipelines/v1/sinks/sink%2F1"
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "sink/1"}}}}

        env.method == :delete ->
          assert url(env) == "/accounts/acc/pipelines/v1/sinks/sink%2F1"
          {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
      end
    end)

    assert {:ok, [%{"id" => "sink"}]} =
             WorkersPipelinesOther.list_sinks(client, "acc", page: 1)

    assert {:ok, ^payload} = WorkersPipelinesOther.create_sink(client, "acc", payload)
    assert {:ok, %{"id" => "sink/1"}} = WorkersPipelinesOther.get_sink(client, "acc", "sink/1")

    assert {:ok, %{"success" => true}} =
             WorkersPipelinesOther.delete_sink(client, "acc", "sink/1")
  end

  test "stream helpers include patch", %{client: client} do
    payload = %{"sql" => "select *"}

    mock(fn %Tesla.Env{} = env ->
      cond do
        env.method == :get && String.contains?(env.url, "/streams?") ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "stream"}]}}}

        env.method == :post ->
          assert url(env) == "/accounts/acc/pipelines/v1/streams"
          assert Jason.decode!(env.body) == payload
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}

        env.method == :get ->
          assert url(env) == "/accounts/acc/pipelines/v1/streams/stream%2F1"
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "stream/1"}}}}

        env.method == :patch ->
          assert url(env) == "/accounts/acc/pipelines/v1/streams/stream%2F1"
          assert Jason.decode!(env.body) == payload
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}

        env.method == :delete ->
          assert url(env) == "/accounts/acc/pipelines/v1/streams/stream%2F1"
          {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
      end
    end)

    assert {:ok, [%{"id" => "stream"}]} =
             WorkersPipelinesOther.list_streams(client, "acc", page: 1)

    assert {:ok, ^payload} = WorkersPipelinesOther.create_stream(client, "acc", payload)

    assert {:ok, %{"id" => "stream/1"}} =
             WorkersPipelinesOther.get_stream(client, "acc", "stream/1")

    assert {:ok, ^payload} =
             WorkersPipelinesOther.update_stream(client, "acc", "stream/1", payload)

    assert {:ok, %{"success" => true}} =
             WorkersPipelinesOther.delete_stream(client, "acc", "stream/1")
  end

  test "validate_sql/3 posts payload", %{client: client} do
    payload = %{"sql" => "select * from foo"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/pipelines/v1/validate_sql"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"valid" => true}}}}
    end)

    assert {:ok, %{"valid" => true}} =
             WorkersPipelinesOther.validate_sql(client, "acc", payload)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 9000}]}}}
    end)

    assert {:error, [_]} = WorkersPipelinesOther.list_pipelines(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
