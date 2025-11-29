defmodule CloudflareApi.UrlScannerTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UrlScanner

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create_scan/3 posts JSON", %{client: client} do
    params = %{"url" => "https://example.com"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/urlscanner/v2/scan"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"scan_id" => "123"}}}}
    end)

    assert {:ok, %{"scan_id" => "123"}} = UrlScanner.create_scan(client, "acc", params)
  end

  test "get_response/3 hits response endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/urlscanner/v2/responses/resp"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "resp"}}}}
    end)

    assert {:ok, %{"id" => "resp"}} =
             UrlScanner.get_response(client, "acc", "resp")
  end

  test "search/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/urlscanner/v2/search?query=example"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             UrlScanner.search(client, "acc", query: "example")
  end
end
