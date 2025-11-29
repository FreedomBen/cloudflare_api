defmodule CloudflareApi.UrlScannerDeprecatedTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UrlScannerDeprecated

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create_scan/3 posts JSON", %{client: client} do
    params = %{"url" => "https://legacy.example"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"scan_id" => "old"}}}}
    end)

    assert {:ok, %{"scan_id" => "old"}} =
             UrlScannerDeprecated.create_scan(client, "acc", params)
  end

  test "get_screenshot/3 hits screenshot endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/urlscanner/scan/scan123/screenshot"

      {:ok, %Tesla.Env{env | status: 200, body: "<<binary>>"}}
    end)

    assert {:ok, "<<binary>>"} =
             UrlScannerDeprecated.get_screenshot(client, "acc", "scan123")
  end

  test "search/3 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 503, body: %{"errors" => [%{"code" => 503}]}}}
    end)

    assert {:error, [%{"code" => 503}]} =
             UrlScannerDeprecated.search(client, "acc")
  end
end
