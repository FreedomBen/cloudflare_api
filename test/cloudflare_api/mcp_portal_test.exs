defmodule CloudflareApi.McpPortalTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.McpPortal

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits the portals collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/access/ai-controls/mcp/portals?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "portal"}]}}}
    end)

    assert {:ok, [%{"name" => "portal"}]} = McpPortal.list(client, "acc", page: 2)
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "sandbox"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = McpPortal.create(client, "acc", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "portal"}}}}
    end)

    assert {:ok, %{"id" => "portal"}} = McpPortal.delete(client, "acc", "portal")
  end

  test "update/4 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             McpPortal.update(client, "acc", "portal", %{"name" => "new"})
  end
end
