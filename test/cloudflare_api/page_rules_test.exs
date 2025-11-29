defmodule CloudflareApi.PageRulesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PageRules

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination options", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/pagerules?status=active"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rule"}]}}}
    end)

    assert {:ok, [%{"id" => "rule"}]} = PageRules.list(client, "zone", status: "active")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"targets" => ["example.com"], "actions" => []}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = PageRules.create(client, "zone", params)
  end

  test "patch/4 uses PATCH and handles response", %{client: client} do
    params = %{"status" => "disabled"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = PageRules.patch(client, "zone", "rule", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = PageRules.delete(client, "zone", "rule")
  end

  test "get/3 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 21}]}}}
    end)

    assert {:error, [%{"code" => 21}]} = PageRules.get(client, "zone", "missing")
  end
end
