defmodule CloudflareApi.WorkerDomainTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerDomain

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/domains?zone_name=example.com&service=my-service"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "domain"}]}}}
    end)

    assert {:ok, [%{"id" => "domain"}]} =
             WorkerDomain.list(client, "acc", zone_name: "example.com", service: "my-service")
  end

  test "attach/3 sends JSON", %{client: client} do
    params = %{"zone_name" => "example.com"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workers/domains"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkerDomain.attach(client, "acc", params)
  end

  test "get/3 fetches a domain", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/workers/domains/dom%2Fa"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "dom/a"}}}}
    end)

    assert {:ok, %{"id" => "dom/a"}} = WorkerDomain.get(client, "acc", "dom/a")
  end

  test "detach/3 issues DELETE with body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/workers/domains/123"
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "123"}}}}
    end)

    assert {:ok, %{"id" => "123"}} = WorkerDomain.detach(client, "acc", "123")
  end

  test "surface API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} = WorkerDomain.list(client, "acc")
  end
end
