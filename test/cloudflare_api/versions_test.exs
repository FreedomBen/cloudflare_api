defmodule CloudflareApi.VersionsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Versions

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/workers/workers/worker/versions?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "v1"}]}}}
    end)

    assert {:ok, [%{"id" => "v1"}]} =
             Versions.list(client, "acc", "worker", page: 2)
  end

  test "create/4 posts payload", %{client: client} do
    params = %{"metadata" => %{}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Versions.create(client, "acc", "worker", params)
  end

  test "delete/4 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1004}]}}}
    end)

    assert {:error, [%{"code" => 1004}]} =
             Versions.delete(client, "acc", "worker", "missing")
  end
end
