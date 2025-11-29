defmodule CloudflareApi.R2SuperSlurperTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.R2SuperSlurper

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_jobs/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/slurper/jobs?per_page=10"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "job"}]}}}
    end)

    assert {:ok, [%{"id" => "job"}]} = R2SuperSlurper.list_jobs(client, "acc", per_page: 10)
  end

  test "create_job/3 posts payload", %{client: client} do
    params = %{"source" => %{"bucket" => "r2"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "job"}}}}
    end)

    assert {:ok, %{"id" => "job"}} = R2SuperSlurper.create_job(client, "acc", params)
  end

  test "pause_job/4 uses PUT", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/slurper/jobs/job/pause"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"state" => "paused"}}}}
    end)

    assert {:ok, %{"state" => "paused"}} = R2SuperSlurper.pause_job(client, "acc", "job")
  end

  test "check_target/3 posts connectivity payload", %{client: client} do
    params = %{"bucket" => "dst"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/slurper/target/connectivity-precheck"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} = R2SuperSlurper.check_target(client, "acc", params)
  end

  test "get_job/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:error, [%{"code" => 42}]} = R2SuperSlurper.get_job(client, "acc", "missing")
  end
end
