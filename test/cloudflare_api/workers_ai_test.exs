defmodule CloudflareApi.WorkersAiTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAi

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "search_authors/2 hits the authors endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/ai/authors/search"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = WorkersAi.search_authors(client, "acc")
  end

  test "get_model_schema/3 encodes query", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/ai/models/schema?model=text%2F1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = WorkersAi.get_model_schema(client, "acc", "text/1")
  end

  test "search_models/3 forwards opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/models/search?task=text-classification&per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersAi.search_models(client, "acc", task: "text-classification", per_page: 5)
  end

  test "run_model/4 posts JSON", %{client: client} do
    params = %{"input_text" => "hi"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/ai/run/my-model"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"output" => "hi"}}}}
    end)

    assert {:ok, %{"output" => "hi"}} =
             WorkersAi.run_model(client, "acc", "my-model", params)
  end

  test "search_tasks/2 calls tasks endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/ai/tasks/search"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = WorkersAi.search_tasks(client, "acc")
  end

  test "convert_to_markdown/4 enforces octet-stream header", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, headers: headers, body: body} = env ->
      assert url == @base <> "/accounts/acc/ai/tomarkdown"
      assert body == "pdf-bytes"
      assert {"content-type", "application/octet-stream"} in headers
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = WorkersAi.convert_to_markdown(client, "acc", "pdf-bytes")
  end

  test "supported_markdown_formats/2 hits supported endpoint", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/ai/tomarkdown/supported"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = WorkersAi.supported_markdown_formats(client, "acc")
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [_]} = WorkersAi.search_models(client, "acc")
  end
end
