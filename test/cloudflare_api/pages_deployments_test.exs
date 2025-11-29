defmodule CloudflareApi.PagesDeploymentsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PagesDeployments

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/pages/projects/proj/deployments?per_page=5"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "dep"}]}}}
    end)

    assert {:ok, [%{"id" => "dep"}]} = PagesDeployments.list(client, "acc", "proj", per_page: 5)
  end

  test "create/4 posts JSON body", %{client: client} do
    params = %{"deployment_trigger" => %{"type" => "preview"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "dep"}}}}
    end)

    assert {:ok, %{"id" => "dep"}} = PagesDeployments.create(client, "acc", "proj", params)
  end

  test "logs/5 hits log endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/pages/projects/proj/deployments/dep/history/logs"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"line" => "ok"}]}}}
    end)

    assert {:ok, [%{"line" => "ok"}]} = PagesDeployments.logs(client, "acc", "proj", "dep")
  end

  test "retry/4 posts empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "queued"}}}}
    end)

    assert {:ok, %{"status" => "queued"}} = PagesDeployments.retry(client, "acc", "proj", "dep")
  end

  test "delete/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} = PagesDeployments.delete(client, "acc", "proj", "dep")
  end
end
