defmodule CloudflareApi.ZoneSnippetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneSnippets

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 forwards pagination parameters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/snippets?page=1&per_page=25"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "foo"}]}}}
    end)

    assert {:ok, [%{"name" => "foo"}]} = ZoneSnippets.list(client, "zone", page: 1, per_page: 25)
  end

  test "snippet CRUD and content helpers hit expected routes", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        if String.ends_with?(url, "/content") do
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "console.log('hi')"}}}
        else
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "foo"}}}}
        end

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/snippets/foo"
        assert Jason.decode!(body) == %{"main_module" => "worker.js"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "foo"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/snippets/foo"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "foo"}} = ZoneSnippets.get(client, "zone", "foo")

    assert {:ok, %{"name" => "foo"}} =
             ZoneSnippets.put(client, "zone", "foo", %{"main_module" => "worker.js"})

    assert {:ok, %{}} = ZoneSnippets.delete(client, "zone", "foo")
    assert {:ok, "console.log('hi')"} = ZoneSnippets.get_content(client, "zone", "foo")
  end

  test "snippet rule helpers cover GET/PUT/DELETE", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/snippets/snippet_rules"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/snippets/snippet_rules"
        assert Jason.decode!(body) == %{"rules" => []}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"updated" => true}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/snippets/snippet_rules"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, []} = ZoneSnippets.list_rules(client, "zone")

    assert {:ok, %{"updated" => true}} =
             ZoneSnippets.update_rules(client, "zone", %{"rules" => []})

    assert {:ok, %{}} = ZoneSnippets.delete_rules(client, "zone")
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"message" => "nope"}]}}}
    end)

    assert {:error, [%{"message" => "nope"}]} = ZoneSnippets.get(client, "zone", "missing")
  end
end
